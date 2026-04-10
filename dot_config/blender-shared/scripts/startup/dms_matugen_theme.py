from __future__ import annotations

from pathlib import Path

import bpy


THEME_PATH = Path(__file__).resolve().parents[1] / "presets/interface_theme/dms_matugen.xml"


def apply_dms_matugen_theme() -> None:
    if not THEME_PATH.exists():
        return

    try:
        bpy.ops.preferences.theme_install(overwrite=True, filepath=str(THEME_PATH))
    except Exception as exc:
        print(f"[dms-matugen-theme] Failed to apply theme: {exc}")


bpy.app.timers.register(apply_dms_matugen_theme, first_interval=0.5, persistent=True)
