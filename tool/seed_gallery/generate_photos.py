#!/usr/bin/env python3
"""Generates the striped placeholder photos under tool/seed_gallery/photos.

Produces solid-color banded PNGs (6 alternating light/dark stripes) with no
external dependencies (stdlib zlib only), so the sample set can be
regenerated without ImageMagick/Pillow. Run directly to (re)generate the
landscape sample photos used to test landscape-format support.
"""

from __future__ import annotations

import struct
import zlib
from pathlib import Path

PHOTOS_DIR = Path(__file__).resolve().parent / "photos"
BAND_COUNT = 6
LANDSCAPE_SIZE = (1200, 900)

LANDSCAPE_PALETTE = {
    "13_landscape": "#1E88E5",  # blue
    "14_landscape": "#FB8C00",  # orange
    "15_landscape": "#43A047",  # green
    "16_landscape": "#FDD835",  # yellow
    "17_landscape": "#D81B60",  # pink
    "18_landscape": "#8E24AA",  # purple
}


def _hex_to_rgb(value: str) -> tuple[int, int, int]:
    value = value.lstrip("#")
    r, g, b = (int(value[i : i + 2], 16) for i in (0, 2, 4))
    return r, g, b


def _mix(
    color: tuple[int, int, int], target: tuple[int, int, int], amount: float
) -> tuple[int, int, int]:
    r, g, b = (round(c + (t - c) * amount) for c, t in zip(color, target))
    return r, g, b


def _band_colors(base_hex: str) -> tuple[tuple[int, int, int], tuple[int, int, int]]:
    base = _hex_to_rgb(base_hex)
    dark = _mix(base, (0, 0, 0), 0.12)
    light = _mix(base, (255, 255, 255), 0.35)
    return dark, light


def _png_bytes(width: int, height: int, rows: list[tuple[int, int, int]]) -> bytes:
    def chunk(tag: bytes, data: bytes) -> bytes:
        return (
            struct.pack(">I", len(data))
            + tag
            + data
            + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)
        )

    raw = bytearray()
    for r, g, b in rows:
        raw.append(0)  # no per-scanline filter
        raw += bytes((r, g, b)) * width

    ihdr = struct.pack(">IIBBBBB", width, height, 8, 2, 0, 0, 0)  # 8-bit RGB
    idat = zlib.compress(bytes(raw), 9)
    return (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", ihdr)
        + chunk(b"IDAT", idat)
        + chunk(b"IEND", b"")
    )


def generate_striped_photo(path: Path, size: tuple[int, int], base_hex: str) -> None:
    width, height = size
    dark, light = _band_colors(base_hex)
    band_height = height // BAND_COUNT

    rows = []
    for y in range(height):
        band = min(y // band_height, BAND_COUNT - 1)
        rows.append(dark if band % 2 == 0 else light)

    path.write_bytes(_png_bytes(width, height, rows))


def main() -> None:
    PHOTOS_DIR.mkdir(parents=True, exist_ok=True)
    for suffix, base_hex in LANDSCAPE_PALETTE.items():
        out = PHOTOS_DIR / f"sample_{suffix}.png"
        generate_striped_photo(out, LANDSCAPE_SIZE, base_hex)
        print(f"Wrote {out}")


if __name__ == "__main__":
    main()
