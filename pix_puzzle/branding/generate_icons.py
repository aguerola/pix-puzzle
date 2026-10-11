#!/usr/bin/env python3
"""Regenerate Pix-Puzzle icons: 3×3 stamp with only the center cell filled."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
BRANDING = Path(__file__).resolve().parent

CREAM = (0xFA, 0xF7, 0xF0, 255)
INK = (0x20, 0x25, 0x2B, 255)
BORDER = (0x73, 0x73, 0x6F, 255)


def draw_stamp(
    size: int,
    *,
    background: tuple[int, int, int, int] | None = CREAM,
    margin_ratio: float = 0.22,
) -> Image.Image:
    img = Image.new("RGBA", (size, size), background or (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    margin = size * margin_ratio
    inner = size - 2 * margin
    cell = inner / 3
    stroke = max(1, round(cell * 0.08))
    for r in range(3):
        for c in range(3):
            x0 = margin + c * cell
            y0 = margin + r * cell
            x1 = x0 + cell
            y1 = y0 + cell
            if c == 1 and r == 1:
                draw.rectangle([x0, y0, x1, y1], fill=INK)
            else:
                # Inset stroke so neighboring cells share a clean grid look.
                draw.rectangle(
                    [x0, y0, x1 - 1, y1 - 1],
                    outline=BORDER,
                    width=stroke,
                )
    return img


def save_png(img: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    img.save(path, format="PNG")


def write_svg(path: Path, size: int = 1024, margin_ratio: float = 0.22) -> None:
    margin = size * margin_ratio
    cell = (size - 2 * margin) / 3
    stroke = max(1, cell * 0.08)
    parts = [
        f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {size} {size}">',
        f'<rect width="{size}" height="{size}" fill="#FAF7F0"/>',
    ]
    for r in range(3):
        for c in range(3):
            x = margin + c * cell
            y = margin + r * cell
            if c == 1 and r == 1:
                parts.append(
                    f'<rect x="{x}" y="{y}" width="{cell}" height="{cell}" fill="#20252B"/>'
                )
            else:
                parts.append(
                    f'<rect x="{x}" y="{y}" width="{cell}" height="{cell}" '
                    f'fill="none" stroke="#73736F" stroke-width="{stroke}"/>'
                )
    parts.append("</svg>")
    path.write_text("\n".join(parts) + "\n", encoding="utf-8")


def android_vector(monochrome: bool = False) -> str:
    vp = 108.0
    margin = vp * 0.28
    cell = (vp - 2 * margin) / 3
    stroke = max(1.0, cell * 0.1)
    border = "#20252B" if monochrome else "#73736F"
    paths: list[str] = []
    for r in range(3):
        for c in range(3):
            x = margin + c * cell
            y = margin + r * cell
            if c == 1 and r == 1:
                paths.append(
                    f'<path android:fillColor="#20252B" '
                    f'android:pathData="M{x},{y}h{cell}v{cell}h-{cell}z"/>'
                )
            else:
                paths.append(
                    f'<path android:fillColor="#00000000" '
                    f'android:strokeColor="{border}" '
                    f'android:strokeWidth="{stroke}" '
                    f'android:pathData="M{x},{y}h{cell}v{cell}h-{cell}z"/>'
                )
    body = "".join(paths)
    return (
        '<vector xmlns:android="http://schemas.android.com/apk/res/android" '
        'android:width="108dp" android:height="108dp" '
        'android:viewportWidth="108" android:viewportHeight="108">'
        f"{body}</vector>\n"
    )


def main() -> None:
    master = BRANDING / "master"
    write_svg(master / "pix-icon.svg")
    save_png(draw_stamp(1024), master / "pix-icon-1024.png")
    save_png(draw_stamp(512), BRANDING / "store" / "google-play-512.png")

    for name, px in {
        "mdpi": 48,
        "hdpi": 72,
        "xhdpi": 96,
        "xxhdpi": 144,
        "xxxhdpi": 192,
    }.items():
        icon = draw_stamp(px)
        base = ROOT / "android/app/src/main/res" / f"mipmap-{name}"
        save_png(icon, base / "ic_launcher.png")
        save_png(icon, base / "ic_launcher_round.png")

    (ROOT / "android/app/src/main/res/drawable/ic_launcher_foreground.xml").write_text(
        android_vector(False), encoding="utf-8"
    )
    (ROOT / "android/app/src/main/res/drawable/ic_launcher_monochrome.xml").write_text(
        android_vector(True), encoding="utf-8"
    )

    ios = ROOT / "ios/Runner/Assets.xcassets/AppIcon.appiconset"
    ios_sizes = {
        "Icon-App-20x20@1x.png": 20,
        "Icon-App-20x20@2x.png": 40,
        "Icon-App-20x20@3x.png": 60,
        "Icon-App-29x29@1x.png": 29,
        "Icon-App-29x29@2x.png": 58,
        "Icon-App-29x29@3x.png": 87,
        "Icon-App-40x40@1x.png": 40,
        "Icon-App-40x40@2x.png": 80,
        "Icon-App-40x40@3x.png": 120,
        "Icon-App-60x60@2x.png": 120,
        "Icon-App-60x60@3x.png": 180,
        "Icon-App-76x76@1x.png": 76,
        "Icon-App-76x76@2x.png": 152,
        "Icon-App-83.5x83.5@2x.png": 167,
        "Icon-App-1024x1024@1x.png": 1024,
    }
    for filename, px in ios_sizes.items():
        save_png(draw_stamp(px), ios / filename)

    web = ROOT / "web"
    icons = web / "icons"
    save_png(draw_stamp(16), icons / "favicon-16.png")
    save_png(draw_stamp(32), icons / "favicon-32.png")
    save_png(draw_stamp(48), icons / "favicon-48.png")
    save_png(draw_stamp(32), web / "favicon.png")
    save_png(draw_stamp(180), icons / "apple-touch-icon.png")
    save_png(draw_stamp(192), icons / "Icon-192.png")
    save_png(draw_stamp(512), icons / "Icon-512.png")
    save_png(draw_stamp(192, margin_ratio=0.32), icons / "Icon-maskable-192.png")
    save_png(draw_stamp(512, margin_ratio=0.32), icons / "Icon-maskable-512.png")

    ico_path = web / "favicon.ico"
    images = [draw_stamp(s).convert("RGBA") for s in (16, 32, 48)]
    images[0].save(
        ico_path,
        format="ICO",
        sizes=[(16, 16), (32, 32), (48, 48)],
        append_images=images[1:],
    )

    print("Generated center-dot stamp icons under branding/, android/, ios/, web/")


if __name__ == "__main__":
    main()
