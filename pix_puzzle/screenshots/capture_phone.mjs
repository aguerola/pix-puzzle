import { spawn } from 'node:child_process';
import { writeFileSync, mkdirSync, rmSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { createInterface } from 'node:readline';
import net from 'node:net';
import WebSocket from 'ws';

const __dirname = dirname(fileURLToPath(import.meta.url));
const OUT = __dirname;
const CHROME =
  '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const WIDTH = 390;
const HEIGHT = 844;
const URL = 'http://localhost:8080/';

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function findPort() {
  return new Promise((resolve, reject) => {
    const s = net.createServer();
    s.listen(0, '127.0.0.1', () => {
      const { port } = s.address();
      s.close(() => resolve(port));
    });
    s.on('error', reject);
  });
}

function connectWs(url) {
  const ws = new WebSocket(url);
  let nextId = 1;
  const pending = new Map();
  const ready = new Promise((res, rej) => {
    ws.once('open', res);
    ws.once('error', rej);
  });
  ws.on('message', (data) => {
    const msg = JSON.parse(data.toString());
    if (msg.id && pending.has(msg.id)) {
      const { resolve, reject } = pending.get(msg.id);
      pending.delete(msg.id);
      if (msg.error) reject(new Error(JSON.stringify(msg.error)));
      else resolve(msg.result);
    }
  });
  const send = (method, params = {}, sessionId) => {
    const id = nextId++;
    const payload = { id, method, params };
    if (sessionId) payload.sessionId = sessionId;
    return new Promise((resolve, reject) => {
      pending.set(id, { resolve, reject });
      ws.send(JSON.stringify(payload));
    });
  };
  return { ws, ready, send };
}

async function main() {
  mkdirSync(OUT, { recursive: true });
  const port = await findPort();
  const userData = join(OUT, '.chrome-profile');
  rmSync(userData, { recursive: true, force: true });

  const chrome = spawn(
    CHROME,
    [
      `--remote-debugging-port=${port}`,
      `--user-data-dir=${userData}`,
      '--headless=new',
      '--disable-gpu',
      '--hide-scrollbars',
      `--window-size=${WIDTH},${HEIGHT}`,
      'about:blank',
    ],
    { stdio: ['ignore', 'pipe', 'pipe'] },
  );

  const rl = createInterface({ input: chrome.stderr });
  for await (const line of rl) {
    if (line.includes('DevTools listening on')) break;
  }

  const version = await fetch(`http://127.0.0.1:${port}/json/version`).then(
    (r) => r.json(),
  );
  const browser = connectWs(version.webSocketDebuggerUrl);
  await browser.ready;

  const targets = await fetch(`http://127.0.0.1:${port}/json/list`).then((r) =>
    r.json(),
  );
  let targetId = targets.find((t) => t.type === 'page')?.id;
  if (!targetId) {
    ({ targetId } = await browser.send('Target.createTarget', {
      url: 'about:blank',
    }));
  }

  const { sessionId } = await browser.send('Target.attachToTarget', {
    targetId,
    flatten: true,
  });
  const page = (method, params = {}) =>
    browser.send(method, params, sessionId);

  await page('Page.enable');
  await page('Runtime.enable');
  await page('Emulation.setDeviceMetricsOverride', {
    width: WIDTH,
    height: HEIGHT,
    deviceScaleFactor: 2,
    mobile: true,
  });
  await page('Page.navigate', { url: URL });
  await sleep(7000);

  async function shot(name) {
    const { data } = await page('Page.captureScreenshot', {
      format: 'png',
      fromSurface: true,
    });
    const path = join(OUT, name);
    writeFileSync(path, Buffer.from(data, 'base64'));
    console.log('wrote', path);
  }

  async function tap(x, y) {
    await page('Input.dispatchMouseEvent', {
      type: 'mousePressed',
      x,
      y,
      button: 'left',
      clickCount: 1,
    });
    await page('Input.dispatchMouseEvent', {
      type: 'mouseReleased',
      x,
      y,
      button: 'left',
      clickCount: 1,
    });
    await sleep(900);
  }

  await shot('phone_home.png');

  // Difficulty buttons are vertically centered (MainAxisAlignment.center).
  const btnX = 62;
  await tap(btnX, 450);
  await shot('phone_home_medium.png');

  await tap(btnX, 500);
  await shot('phone_home_hard.png');

  await tap(btnX, 400);
  await sleep(600);
  // First level row in the list
  await tap(220, 120);
  await sleep(2500);
  await shot('phone_game.png');

  await browser.send('Browser.close').catch(() => {});
  chrome.kill('SIGTERM');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
