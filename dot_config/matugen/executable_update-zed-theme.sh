#!/bin/bash

# Script to update Zed theme from ghostty colors
# Run this whenever ghostty theme changes (e.g., via matugen hook)

GHOSTTY_THEME="$HOME/.config/ghostty/themes/dankcolors"
ZED_THEME_DIR="$HOME/.config/zed/themes"
ZED_THEME_FILE="$ZED_THEME_DIR/dankcolors.json"

# Check if ghostty theme exists
if [[ ! -f "$GHOSTTY_THEME" ]]; then
    echo "Error: Ghostty theme not found at $GHOSTTY_THEME" >&2
    exit 1
fi

# Ensure Zed themes directory exists
mkdir -p "$ZED_THEME_DIR"

# Helper function to adjust hex color brightness
adjust_color() {
    local color=$1
    local percent=$2
    
    # Strip # prefix if present
    color=${color#\#}
    
    # Convert hex to rgb
    local r=$((16#${color:0:2}))
    local g=$((16#${color:2:2}))
    local b=$((16#${color:4:2}))
    
    # Calculate adjustment
    if [[ $percent -gt 0 ]]; then
        r=$((r + (255 - r) * percent / 100))
        g=$((g + (255 - g) * percent / 100))
        b=$((b + (255 - b) * percent / 100))
    else
        r=$((r * (100 + percent) / 100))
        g=$((g * (100 + percent) / 100))
        b=$((b * (100 + percent) / 100))
    fi
    
    # Clamp values
    r=$((r < 0 ? 0 : (r > 255 ? 255 : r)))
    g=$((g < 0 ? 0 : (g > 255 ? 255 : g)))
    b=$((b < 0 ? 0 : (b > 255 ? 255 : b)))
    
    # Convert back to hex with # prefix
    printf "#%02x%02x%02x" $r $g $b
}

# Parse ghostty theme colors (keep # prefix)
parse_color() {
    local key=$1
    grep "^$key = " "$GHOSTTY_THEME" | sed 's/.* = //'
}

# Get all the colors
BG=$(parse_color "background")
FG=$(parse_color "foreground")
CURSOR=$(parse_color "cursor-color")
SEL_BG=$(parse_color "selection-background")
SEL_FG=$(parse_color "selection-foreground")

# Parse palette (0-15) - keep # prefix
declare -A PALETTE
for i in {0..15}; do
    PALETTE[$i]=$(grep "^palette = $i=#" "$GHOSTTY_THEME" | sed "s/palette = $i=//")
done

# Pre-compute adjusted colors
BG_LIGHT3=$(adjust_color $BG 3)
BG_LIGHT5=$(adjust_color $BG 5)
BG_LIGHT8=$(adjust_color $BG 8)
BG_LIGHT10=$(adjust_color $BG 10)
BG_LIGHT15=$(adjust_color $BG 15)

# Helper function to add alpha channel
rgba() {
    local color=$1
    local alpha=$2
    echo "${color}${alpha}"
}

# Generate the theme JSON
cat > "$ZED_THEME_FILE" << EOF
{
  "\$schema": "https://zed.dev/schema/themes/v0.2.0.json",
  "name": "Dank Colors",
  "author": "Generated from ghostty dankcolors",
  "themes": [
    {
      "name": "Dank Colors",
      "appearance": "dark",
      "style": {
        "border": "${BG_LIGHT10}ff",
        "border.variant": "${BG_LIGHT8}ff",
        "border.focused": "${CURSOR}ff",
        "border.selected": "${PALETTE[4]}ff",
        "border.transparent": "#00000000",
        "border.disabled": "${PALETTE[8]}ff",
        "elevated_surface.background": "${BG_LIGHT3}ff",
        "surface.background": "${BG_LIGHT3}ff",
        "background": "${BG}ff",
        "element.background": "${BG_LIGHT5}ff",
        "element.hover": "${BG_LIGHT10}ff",
        "element.active": "${BG_LIGHT15}ff",
        "element.selected": "${BG_LIGHT15}ff",
        "element.disabled": "${BG_LIGHT5}ff",
        "drop_target.background": "${CURSOR}80",
        "ghost_element.background": "#00000000",
        "ghost_element.hover": "${BG_LIGHT10}ff",
        "ghost_element.active": "${BG_LIGHT15}ff",
        "ghost_element.selected": "${BG_LIGHT15}ff",
        "ghost_element.disabled": "${BG_LIGHT5}ff",
        "text": "${FG}ff",
        "text.muted": "${PALETTE[7]}ff",
        "text.placeholder": "${PALETTE[8]}ff",
        "text.disabled": "${PALETTE[8]}ff",
        "text.accent": "${CURSOR}ff",
        "icon": "${FG}ff",
        "icon.muted": "${PALETTE[7]}ff",
        "icon.disabled": "${PALETTE[8]}ff",
        "icon.placeholder": "${PALETTE[7]}ff",
        "icon.accent": "${CURSOR}ff",
        "status_bar.background": "${BG}ff",
        "title_bar.background": "${BG}ff",
        "title_bar.inactive_background": "${BG_LIGHT3}ff",
        "toolbar.background": "${BG_LIGHT3}ff",
        "tab_bar.background": "${BG_LIGHT3}ff",
        "tab.inactive_background": "${BG_LIGHT3}ff",
        "tab.active_background": "${BG_LIGHT5}ff",
        "search.match_background": "${CURSOR}66",
        "search.active_match_background": "${PALETTE[3]}66",
        "panel.background": "${BG_LIGHT3}ff",
        "panel.focused_border": null,
        "pane.focused_border": null,
        "scrollbar.thumb.background": "${PALETTE[8]}4c",
        "scrollbar.thumb.hover_background": "${BG_LIGHT10}ff",
        "scrollbar.thumb.border": "${BG_LIGHT10}ff",
        "scrollbar.track.background": "#00000000",
        "scrollbar.track.border": "${BG_LIGHT5}ff",
        "editor.foreground": "${FG}ff",
        "editor.background": "${BG}ff",
        "editor.gutter.background": "${BG}ff",
        "editor.subheader.background": "${BG_LIGHT3}ff",
        "editor.active_line.background": "${BG_LIGHT5}40",
        "editor.highlighted_line.background": "${BG_LIGHT5}ff",
        "editor.line_number": "${PALETTE[8]}ff",
        "editor.active_line_number": "${FG}ff",
        "editor.hover_line_number": "${PALETTE[7]}ff",
        "editor.invisible": "${PALETTE[8]}ff",
        "editor.wrap_guide": "${PALETTE[8]}0d",
        "editor.active_wrap_guide": "${PALETTE[8]}1a",
        "editor.document_highlight.read_background": "${CURSOR}1a",
        "editor.document_highlight.write_background": "${SEL_BG}66",
        "terminal.background": "${BG}ff",
        "terminal.foreground": "${FG}ff",
        "terminal.bright_foreground": "${PALETTE[15]}ff",
        "terminal.dim_foreground": "${PALETTE[8]}ff",
        "terminal.ansi.black": "${PALETTE[0]}ff",
        "terminal.ansi.bright_black": "${PALETTE[8]}ff",
        "terminal.ansi.dim_black": "${BG_LIGHT5}ff",
        "terminal.ansi.red": "${PALETTE[1]}ff",
        "terminal.ansi.bright_red": "${PALETTE[9]}ff",
        "terminal.ansi.green": "${PALETTE[2]}ff",
        "terminal.ansi.bright_green": "${PALETTE[10]}ff",
        "terminal.ansi.yellow": "${PALETTE[3]}ff",
        "terminal.ansi.bright_yellow": "${PALETTE[11]}ff",
        "terminal.ansi.blue": "${PALETTE[4]}ff",
        "terminal.ansi.bright_blue": "${PALETTE[12]}ff",
        "terminal.ansi.magenta": "${PALETTE[5]}ff",
        "terminal.ansi.bright_magenta": "${PALETTE[13]}ff",
        "terminal.ansi.cyan": "${PALETTE[6]}ff",
        "terminal.ansi.bright_cyan": "${PALETTE[14]}ff",
        "terminal.ansi.dim_white": "#8a8a8aff",
        "terminal.ansi.white": "${PALETTE[7]}ff",
        "terminal.ansi.bright_white": "${PALETTE[15]}ff",
        "link_text.hover": "${CURSOR}ff",
        "version_control.added": "${PALETTE[2]}ff",
        "version_control.modified": "${PALETTE[3]}ff",
        "version_control.word_added": "${PALETTE[2]}59",
        "version_control.word_deleted": "${PALETTE[1]}cc",
        "version_control.deleted": "${PALETTE[1]}ff",
        "version_control.conflict_marker.ours": "${PALETTE[2]}1a",
        "version_control.conflict_marker.theirs": "${CURSOR}1a",
        "conflict": "${PALETTE[3]}ff",
        "conflict.background": "${PALETTE[3]}1a",
        "conflict.border": "#5c4c2fff",
        "created": "${PALETTE[2]}ff",
        "created.background": "${PALETTE[2]}1a",
        "created.border": "#38482fff",
        "deleted": "${PALETTE[1]}ff",
        "deleted.background": "${PALETTE[1]}1a",
        "deleted.border": "#4c2b2cff",
        "error": "${PALETTE[1]}ff",
        "error.background": "${PALETTE[1]}1a",
        "error.border": "#4c2b2cff",
        "hidden": "${PALETTE[8]}ff",
        "hidden.background": "${PALETTE[8]}1a",
        "hidden.border": "${PALETTE[8]}ff",
        "hint": "${PALETTE[5]}ff",
        "hint.background": "${PALETTE[5]}1a",
        "hint.border": "${PALETTE[4]}ff",
        "ignored": "${PALETTE[8]}ff",
        "ignored.background": "${PALETTE[8]}1a",
        "ignored.border": "${PALETTE[8]}ff",
        "info": "${CURSOR}ff",
        "info.background": "${CURSOR}1a",
        "info.border": "${PALETTE[4]}ff",
        "modified": "${PALETTE[3]}ff",
        "modified.background": "${PALETTE[3]}1a",
        "modified.border": "#5c4c2fff",
        "predictive": "${PALETTE[5]}ff",
        "predictive.background": "${PALETTE[5]}1a",
        "predictive.border": "${PALETTE[4]}ff",
        "renamed": "${CURSOR}ff",
        "renamed.background": "${CURSOR}1a",
        "renamed.border": "${PALETTE[4]}ff",
        "success": "${PALETTE[2]}ff",
        "success.background": "${PALETTE[2]}1a",
        "success.border": "#38482fff",
        "unreachable": "${PALETTE[7]}ff",
        "unreachable.background": "${PALETTE[7]}1a",
        "unreachable.border": "${PALETTE[8]}ff",
        "warning": "${PALETTE[3]}ff",
        "warning.background": "${PALETTE[3]}1a",
        "warning.border": "#5c4c2fff",
        "players": [
          {
            "cursor": "${CURSOR}ff",
            "background": "${CURSOR}ff",
            "selection": "${CURSOR}3d"
          },
          {
            "cursor": "${PALETTE[1]}ff",
            "background": "${PALETTE[1]}ff",
            "selection": "${PALETTE[1]}3d"
          },
          {
            "cursor": "${PALETTE[3]}ff",
            "background": "${PALETTE[3]}ff",
            "selection": "${PALETTE[3]}3d"
          },
          {
            "cursor": "${PALETTE[4]}ff",
            "background": "${PALETTE[4]}ff",
            "selection": "${PALETTE[4]}3d"
          },
          {
            "cursor": "${PALETTE[2]}ff",
            "background": "${PALETTE[2]}ff",
            "selection": "${PALETTE[2]}3d"
          },
          {
            "cursor": "${PALETTE[5]}ff",
            "background": "${PALETTE[5]}ff",
            "selection": "${PALETTE[5]}3d"
          }
        ],
        "syntax": {
          "attribute": { "color": "${CURSOR}ff", "font_style": null, "font_weight": null },
          "boolean": { "color": "${PALETTE[3]}ff", "font_style": null, "font_weight": null },
          "comment": { "color": "${PALETTE[8]}ff", "font_style": null, "font_weight": null },
          "comment.doc": { "color": "${PALETTE[5]}ff", "font_style": null, "font_weight": null },
          "constant": { "color": "${PALETTE[3]}ff", "font_style": null, "font_weight": null },
          "constructor": { "color": "${CURSOR}ff", "font_style": null, "font_weight": null },
          "embedded": { "color": "${FG}ff", "font_style": null, "font_weight": null },
          "emphasis": { "color": "${CURSOR}ff", "font_style": null, "font_weight": null },
          "emphasis.strong": { "color": "${PALETTE[3]}ff", "font_style": null, "font_weight": 700 },
          "enum": { "color": "${PALETTE[4]}ff", "font_style": null, "font_weight": null },
          "function": { "color": "${PALETTE[3]}ff", "font_style": null, "font_weight": null },
          "hint": { "color": "${PALETTE[5]}ff", "font_style": null, "font_weight": null },
          "keyword": { "color": "${PALETTE[1]}ff", "font_style": null, "font_weight": null },
          "label": { "color": "${CURSOR}ff", "font_style": null, "font_weight": null },
          "link_text": { "color": "${CURSOR}ff", "font_style": "normal", "font_weight": null },
          "link_uri": { "color": "${PALETTE[4]}ff", "font_style": null, "font_weight": null },
          "namespace": { "color": "${FG}ff", "font_style": null, "font_weight": null },
          "number": { "color": "${PALETTE[3]}ff", "font_style": null, "font_weight": null },
          "operator": { "color": "${PALETTE[4]}ff", "font_style": null, "font_weight": null },
          "predictive": { "color": "${PALETTE[5]}ff", "font_style": "italic", "font_weight": null },
          "preproc": { "color": "${FG}ff", "font_style": null, "font_weight": null },
          "primary": { "color": "${FG}ff", "font_style": null, "font_weight": null },
          "property": { "color": "${PALETTE[1]}ff", "font_style": null, "font_weight": null },
          "punctuation": { "color": "${PALETTE[7]}ff", "font_style": null, "font_weight": null },
          "punctuation.bracket": { "color": "${PALETTE[7]}ff", "font_style": null, "font_weight": null },
          "punctuation.delimiter": { "color": "${PALETTE[7]}ff", "font_style": null, "font_weight": null },
          "punctuation.list_marker": { "color": "${PALETTE[1]}ff", "font_style": null, "font_weight": null },
          "punctuation.markup": { "color": "${PALETTE[1]}ff", "font_style": null, "font_weight": null },
          "punctuation.special": { "color": "${PALETTE[1]}ff", "font_style": null, "font_weight": null },
          "selector": { "color": "${PALETTE[2]}ff", "font_style": null, "font_weight": null },
          "selector.pseudo": { "color": "${CURSOR}ff", "font_style": null, "font_weight": null },
          "string": { "color": "${PALETTE[2]}ff", "font_style": null, "font_weight": null },
          "string.escape": { "color": "${PALETTE[8]}ff", "font_style": null, "font_weight": null },
          "string.regex": { "color": "${PALETTE[3]}ff", "font_style": null, "font_weight": null },
          "string.special": { "color": "${PALETTE[3]}ff", "font_style": null, "font_weight": null },
          "string.special.symbol": { "color": "${PALETTE[3]}ff", "font_style": null, "font_weight": null },
          "tag": { "color": "${CURSOR}ff", "font_style": null, "font_weight": null },
          "text.literal": { "color": "${PALETTE[2]}ff", "font_style": null, "font_weight": null },
          "title": { "color": "${PALETTE[1]}ff", "font_style": null, "font_weight": 400 },
          "type": { "color": "${PALETTE[4]}ff", "font_style": null, "font_weight": null },
          "variable": { "color": "${FG}ff", "font_style": null, "font_weight": null },
          "variable.special": { "color": "${PALETTE[3]}ff", "font_style": null, "font_weight": null },
          "variant": { "color": "${CURSOR}ff", "font_style": null, "font_weight": null }
        }
      }
    }
  ]
}
EOF

echo "Updated Zed theme: $ZED_THEME_FILE"
