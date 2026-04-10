#!/bin/bash

set -euo pipefail

GHOSTTY_THEME="$HOME/.config/ghostty/themes/dankcolors"
BLENDER_SHARED_ROOT="$HOME/.config/blender-shared"
BLENDER_USER_SCRIPTS="$BLENDER_SHARED_ROOT/scripts"
BLENDER_THEME_DIR="$BLENDER_USER_SCRIPTS/presets/interface_theme"
BLENDER_THEME_FILE="$BLENDER_THEME_DIR/dms_matugen.xml"
BLENDER_TEMPLATE_CACHE="$BLENDER_SHARED_ROOT/cache/nocturna-base.xml"

if [[ ! -f "$GHOSTTY_THEME" ]]; then
    echo "Error: Ghostty theme not found at $GHOSTTY_THEME" >&2
    exit 1
fi

mkdir -p "$BLENDER_THEME_DIR"
mkdir -p "${BLENDER_TEMPLATE_CACHE%/*}"

python3 - <<'PY'
from __future__ import annotations

import glob
import re
import shutil
from pathlib import Path


GHOSTTY_THEME = Path.home() / ".config/ghostty/themes/dankcolors"
BLENDER_SHARED_ROOT = Path.home() / ".config/blender-shared"
BLENDER_THEME_FILE = BLENDER_SHARED_ROOT / "scripts/presets/interface_theme/dms_matugen.xml"
BLENDER_TEMPLATE_CACHE = BLENDER_SHARED_ROOT / "cache/nocturna-base.xml"


def parse_ghostty_theme(path: Path) -> dict[str, str | list[str]]:
    data: dict[str, str | list[str]] = {"palette": [""] * 16}
    for raw_line in path.read_text().splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith("palette = "):
            idx_part, value = line.removeprefix("palette = ").split("=", 1)
            data["palette"][int(idx_part)] = value.strip()
            continue
        key, value = line.split("=", 1)
        data[key.strip()] = value.strip()
    return data


def clamp(value: int) -> int:
    return max(0, min(255, value))


def adjust_color(color: str, percent: int) -> str:
    color = color.lstrip("#")
    r = int(color[0:2], 16)
    g = int(color[2:4], 16)
    b = int(color[4:6], 16)

    if percent >= 0:
        r = r + (255 - r) * percent // 100
        g = g + (255 - g) * percent // 100
        b = b + (255 - b) * percent // 100
    else:
        r = r * (100 + percent) // 100
        g = g * (100 + percent) // 100
        b = b * (100 + percent) // 100

    return f"#{clamp(r):02x}{clamp(g):02x}{clamp(b):02x}"


def ensure_template(cache_path: Path) -> Path:
    if cache_path.exists():
        return cache_path

    candidates = sorted(
        glob.glob(str(Path.home() / ".config/blender/*/extensions/blender_org/nocturna_theme/Nocturnav1_2_1.xml")),
        reverse=True,
    )
    if not candidates:
        raise SystemExit(
            "Error: Could not locate a Blender theme template. Install Nocturna once, then rerun this script."
        )

    source = Path(candidates[0])
    cache_path.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, cache_path)
    return cache_path


def replace_theme_colors(template_text: str, theme: dict[str, str | list[str]]) -> str:
    palette = theme["palette"]
    assert isinstance(palette, list)

    bg = str(theme["background"])
    fg = str(theme["foreground"])
    cursor = str(theme["cursor-color"])
    selection_bg = str(theme["selection-background"])

    bg_3 = adjust_color(bg, 3)
    bg_5 = adjust_color(bg, 5)
    bg_8 = adjust_color(bg, 8)
    bg_10 = adjust_color(bg, 10)
    bg_15 = adjust_color(bg, 15)
    bg_20 = adjust_color(bg, 20)
    bg_dark_5 = adjust_color(bg, -5)
    bg_dark_10 = adjust_color(bg, -10)

    rgb_map = {
        "000000": bg,
        "080808": bg_dark_10,
        "101010": bg_dark_10,
        "141414": bg_dark_5,
        "171717": bg_dark_5,
        "1b1b1b": bg,
        "1d1d1d": bg,
        "1e1e1e": bg,
        "1f1f1f": bg_3,
        "202020": bg_3,
        "222222": bg_5,
        "232323": bg_5,
        "252525": bg_8,
        "262626": bg_10,
        "3c3c3c": bg_15,
        "3d3d3d": palette[8],
        "545454": palette[8],
        "727272": palette[8],
        "9a9a9a": palette[7],
        "f2f2f2": fg,
        "fbfbfb": palette[15],
        "ffffff": palette[15],
        "2769bf": cursor,
        "2b72d0": cursor,
        "399aff": palette[12],
        "4772b3": palette[4],
        "1768ff": palette[12],
        "378eff": palette[12],
        "41e164": palette[2],
        "8eff00": palette[10],
        "00b98e": palette[6],
        "e1355e": palette[1],
        "f71f1f": palette[9],
        "ab3c48": selection_bg,
        "ff3e3e": palette[9],
        "edba18": palette[3],
        "f28931": palette[11],
    }

    color_re = re.compile(r"#([0-9a-fA-F]{6})([0-9a-fA-F]{2})?")

    def replace(match: re.Match[str]) -> str:
        rgb = match.group(1).lower()
        alpha = match.group(2)
        replacement = rgb_map.get(rgb)
        if replacement is None:
            return match.group(0)
        replacement_rgb = replacement.lstrip("#")
        return f"#{replacement_rgb}{alpha.lower()}" if alpha else f"#{replacement_rgb}"

    themed = color_re.sub(replace, template_text)
    themed = themed.replace("Nocturnav1_2_1", "DMS_Matugen_Dynamic")
    themed = themed.replace("nocturna", "dms_matugen_dynamic")
    return themed


theme = parse_ghostty_theme(GHOSTTY_THEME)
template_path = ensure_template(BLENDER_TEMPLATE_CACHE)
template_text = template_path.read_text()
themed_text = replace_theme_colors(template_text, theme)
BLENDER_THEME_FILE.write_text(themed_text)

palette = theme["palette"]
assert isinstance(palette, list)
print(f"Updated Blender theme: {BLENDER_THEME_FILE}")
print(f"  Background: {theme['background']}")
print(f"  Foreground: {theme['foreground']}")
print(f"  Accent: {theme['cursor-color']}")
print(f"  Highlight: {palette[12]}")
PY
