#!/usr/bin/env python3
"""Draw each level's target pattern (tableModel) for naming.

Board axes match the game: table[x][y] is column x, row y, with y = 0 at the top.
Filled cells use the app ink; empty cells use the board background.

Examples:
  python3 scripts/preview_levels.py --difficulty 1
  python3 scripts/preview_levels.py --difficulty 2 --out /tmp/pix-levels
"""

from __future__ import annotations

import argparse
import json
import struct
import zlib
from pathlib import Path

INK = (0x20, 0x25, 0x2B)
EMPTY = (0xFF, 0xFC, 0xF7)
BORDER = (0x73, 0x73, 0x6F)
PAPER = (0xFA, 0xF7, 0xF0)
LABEL = (0x20, 0x25, 0x2B)

# 3x5 digits, left to right, top to bottom.
DIGITS = {
    "0": ("111", "101", "101", "101", "111"),
    "1": ("010", "110", "010", "010", "111"),
    "2": ("111", "001", "111", "100", "111"),
    "3": ("111", "001", "111", "001", "111"),
    "4": ("101", "101", "111", "001", "001"),
    "5": ("111", "100", "111", "001", "111"),
    "6": ("111", "100", "111", "101", "111"),
    "7": ("111", "001", "001", "001", "001"),
    "8": ("111", "101", "111", "101", "111"),
    "9": ("111", "101", "111", "001", "111"),
}


def write_png(path: Path, width: int, height: int, rgb: bytearray) -> None:
    def chunk(tag: bytes, data: bytes) -> bytes:
        return (
            struct.pack(">I", len(data))
            + tag
            + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
        )

    raw = bytearray()
    stride = width * 3
    for y in range(height):
        raw.append(0)
        raw.extend(rgb[y * stride : (y + 1) * stride])
    png = b"\x89PNG\r\n\x1a\n"
    png += chunk(b"IHDR", struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0))
    png += chunk(b"IDAT", zlib.compress(bytes(raw), 9))
    png += chunk(b"IEND", b"")
    path.write_bytes(png)


class Canvas:
    def __init__(self, width: int, height: int, color: tuple[int, int, int] = PAPER):
        self.width = width
        self.height = height
        self.rgb = bytearray(color * width * height)

    def set(self, x: int, y: int, color: tuple[int, int, int]) -> None:
        if 0 <= x < self.width and 0 <= y < self.height:
            i = (y * self.width + x) * 3
            self.rgb[i : i + 3] = bytes(color)

    def rect(
        self, x: int, y: int, w: int, h: int, color: tuple[int, int, int]
    ) -> None:
        for yy in range(y, y + h):
            for xx in range(x, x + w):
                self.set(xx, yy, color)

    def text(self, x: int, y: int, text: str, scale: int = 2) -> None:
        cursor = x
        for ch in text:
            glyph = DIGITS.get(ch)
            if glyph is None:
                cursor += 4 * scale
                continue
            for row, bits in enumerate(glyph):
                for col, bit in enumerate(bits):
                    if bit == "1":
                        self.rect(
                            cursor + col * scale,
                            y + row * scale,
                            scale,
                            scale,
                            LABEL,
                        )
            cursor += 4 * scale

    def save(self, path: Path) -> None:
        write_png(path, self.width, self.height, self.rgb)


def model_grid(level: dict) -> list[list[bool]]:
    """Rows top-to-bottom, each row left-to-right. Source is [x][y]."""
    table = level["tableModel"]
    size = level["size"]
    return [[bool(table[x][y]["fill"]) for x in range(size)] for y in range(size)]


def ascii_grid(rows: list[list[bool]]) -> str:
    return "\n".join("".join("██" if cell else "··" for cell in row) for row in rows)


def draw_grid(
    canvas: Canvas,
    rows: list[list[bool]],
    origin_x: int,
    origin_y: int,
    cell: int,
    gap: int,
) -> None:
    for y, row in enumerate(rows):
        for x, filled in enumerate(row):
            canvas.rect(
                origin_x + x * (cell + gap),
                origin_y + y * (cell + gap),
                cell,
                cell,
                INK if filled else EMPTY,
            )
            canvas.rect(
                origin_x + x * (cell + gap),
                origin_y + y * (cell + gap),
                cell,
                1,
                BORDER,
            )
            canvas.rect(
                origin_x + x * (cell + gap),
                origin_y + y * (cell + gap),
                1,
                cell,
                BORDER,
            )


def render_level(level: dict, out: Path, cell: int) -> list[list[bool]]:
    rows = model_grid(level)
    size = len(rows)
    gap = 2
    pad = 16
    label_h = 22
    grid = size * cell + (size - 1) * gap
    canvas = Canvas(grid + pad * 2, grid + pad + label_h + 8)
    canvas.text(pad, 8, str(level["number"]), scale=3)
    draw_grid(canvas, rows, pad, label_h, cell, gap)
    canvas.save(out / f"{level['difficulty']}_{level['number']:03d}.png")
    return rows


def render_sheet(levels: list[dict], out: Path, cell: int) -> None:
    gap = 2
    pad = 28
    label_h = 18
    max_size = max(level["size"] for level in levels)
    slot = max_size * cell + (max_size - 1) * gap
    tile_w = slot + pad
    tile_h = slot + label_h + pad
    cols = 4 if len(levels) > 4 else len(levels)
    rows_n = (len(levels) + cols - 1) // cols
    canvas = Canvas(cols * tile_w + pad, rows_n * tile_h + pad)
    for index, level in enumerate(levels):
        col = index % cols
        row = index // cols
        ox = pad + col * tile_w
        oy = pad + row * tile_h
        canvas.text(ox, oy, str(level["number"]), scale=2)
        grid = model_grid(level)
        extra = max_size - len(grid)
        inset = extra * (cell + gap) // 2
        draw_grid(canvas, grid, ox + inset, oy + label_h + inset, cell, gap)
    canvas.save(out / "sheet.png")


def _spanish_title(level: dict) -> str:
    title = level["title"]
    if isinstance(title, dict):
        return title.get("es") or ""
    return str(title)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--levels",
        type=Path,
        default=Path("pix_puzzle/assets/levels.json"),
    )
    parser.add_argument(
        "--difficulty",
        default="1",
        help="Difficulty id: 1 fácil, 2 media, 3 difícil. Use 'all' for every level.",
    )
    parser.add_argument("--out", type=Path, default=Path("level-previews"))
    parser.add_argument("--cell", type=int, default=28)
    args = parser.parse_args()

    catalog = json.loads(args.levels.read_text())
    levels = catalog["levelList"]
    if args.difficulty != "all":
        difficulty = int(args.difficulty)
        levels = [level for level in levels if level["difficulty"] == difficulty]
    levels.sort(key=lambda level: (level["difficulty"], level["number"]))
    if not levels:
        raise SystemExit(f"No levels for difficulty {args.difficulty!r}")

    args.out.mkdir(parents=True, exist_ok=True)
    print(f"{len(levels)} levels -> {args.out}")
    for level in levels:
        rows = render_level(level, args.out, args.cell)
        print(
            f"\n{level['difficulty']}.{level['number']} {_spanish_title(level)}  {level['size']}×{level['size']}"
        )
        print(ascii_grid(rows))
    render_sheet(levels, args.out, cell=18)
    print(f"\nsheet: {args.out / 'sheet.png'}")


if __name__ == "__main__":
    main()
