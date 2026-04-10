#!/bin/bash
#
# update-theme-colors.sh
# Merged script that updates Discord CSS and generates editor/terminal themes from ghostty colors
# Add this to your Dank Hook to auto-update when matugen regenerates colors
#

GHOSTTY_THEME="$HOME/.config/ghostty/themes/dankcolors"
DISCORD_CSS="$HOME/.var/app/com.discordapp.Discord/config/Vencord/themes/dankcolors-discord.css"
LAZYGIT_CONFIG_DIR="$HOME/.config/lazygit"
LAZYGIT_CONFIG_FILE="$LAZYGIT_CONFIG_DIR/config.yml"
ZELLIJ_CONFIG="$HOME/.config/zellij/config.kdl"
ZELLIJ_THEME_DIR="$HOME/.config/zellij/themes"
ZELLIJ_THEME_FILE="$ZELLIJ_THEME_DIR/dankcolors.kdl"
ZED_THEME_DIR="$HOME/.config/zed/themes"
ZED_THEME_FILE="$ZED_THEME_DIR/dankcolors.json"
BLENDER_THEME_SCRIPT="$HOME/.config/matugen/update-blender-theme.sh"

# Track what was updated
UPDATED=()

# Check if ghostty theme exists
if [[ ! -f "$GHOSTTY_THEME" ]]; then
    echo "Error: Ghostty theme not found at $GHOSTTY_THEME"
    exit 1
fi

# Shared helper function: Convert hex to RGB for rgba
hex_to_rgb() {
    local hex="${1#\#}"
    printf "%d, %d, %d" 0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}
}

# Shared helper function: Convert hex to space-separated RGB for Zellij KDL
hex_to_space_rgb() {
    local hex="${1#\#}"
    printf "%d %d %d" 0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}
}

sync_zellij_theme_block() {
    local block
    block=$(<"$ZELLIJ_THEME_FILE")
    BLOCK="$block" perl -0pi -e 's{// BEGIN DANKCOLORS THEME\n.*?\n// END DANKCOLORS THEME}{"// BEGIN DANKCOLORS THEME\n$ENV{BLOCK}\n// END DANKCOLORS THEME"}se' "$ZELLIJ_CONFIG"
}

# Shared helper function: Parse ghostty theme colors (keep # prefix)
parse_color() {
    local key=$1
    grep "^$key = " "$GHOSTTY_THEME" | sed 's/.* = //'
}

# Shared helper function: Adjust hex color brightness
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

# ============================================================
# STEP 1: Extract all colors from ghostty theme once
# ============================================================

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

# For Discord script compatibility
P0="${PALETTE[0]}"
P1="${PALETTE[1]}"
P2="${PALETTE[2]}"
P3="${PALETTE[3]}"
P4="${PALETTE[4]}"
P5="${PALETTE[5]}"
P6="${PALETTE[6]}"
P7="${PALETTE[7]}"
P8="${PALETTE[8]}"
P9="${PALETTE[9]}"
P10="${PALETTE[10]}"
P11="${PALETTE[11]}"
P12="${PALETTE[12]}"
P13="${PALETTE[13]}"
P14="${PALETTE[14]}"
P15="${PALETTE[15]}"

# Convert cursor to RGB for Discord rgba values
CURSOR_RGB=$(hex_to_rgb "$CURSOR")

# ============================================================
# STEP 2: Update Discord CSS (warn if missing but don't exit)
# ============================================================

if [[ ! -f "$DISCORD_CSS" ]]; then
    echo "Warning: Discord CSS not found at $DISCORD_CSS (skipping Discord update)"
else
    # Update CSS with ghostty colors
    sed -i "s/--text-0: #.*/--text-0: ${BG};/" "$DISCORD_CSS"
    sed -i "s/--text-1: #.*/--text-1: ${P15};/" "$DISCORD_CSS"
    sed -i "s/--text-2: #.*/--text-2: ${P7};/" "$DISCORD_CSS"
    sed -i "s/--text-3: #.*/--text-3: ${FG};/" "$DISCORD_CSS"
    sed -i "s/--text-4: #.*/--text-4: ${P6};/" "$DISCORD_CSS"
    sed -i "s/--text-5: #.*/--text-5: ${P8};/" "$DISCORD_CSS"

    sed -i "s/--bg-1: #.*/--bg-1: ${P13};/" "$DISCORD_CSS"
    sed -i "s/--bg-2: #.*/--bg-2: ${P14};/" "$DISCORD_CSS"
    sed -i "s/--bg-3: #.*/--bg-3: ${P0};/" "$DISCORD_CSS"
    sed -i "s/--bg-4: #.*/--bg-4: ${BG};/" "$DISCORD_CSS"

    sed -i "s/--accent-1: #.*/--accent-1: ${P12};/" "$DISCORD_CSS"
    sed -i "s/--accent-2: #.*/--accent-2: ${CURSOR};/" "$DISCORD_CSS"
    sed -i "s/--accent-3: #.*/--accent-3: ${P4};/" "$DISCORD_CSS"
    sed -i "s/--accent-4: #.*/--accent-4: ${P14};/" "$DISCORD_CSS"
    sed -i "s/--accent-5: #.*/--accent-5: ${SEL_BG};/" "$DISCORD_CSS"
    sed -i "s/--accent-new: #.*/--accent-new: ${P1};/" "$DISCORD_CSS"

    sed -i "s/--online: #.*/--online: ${P2};/" "$DISCORD_CSS"
    sed -i "s/--dnd: #.*/--dnd: ${P1};/" "$DISCORD_CSS"
    sed -i "s/--idle: #.*/--idle: ${P3};/" "$DISCORD_CSS"
    sed -i "s/--streaming: #.*/--streaming: ${P5};/" "$DISCORD_CSS"
    sed -i "s/--offline: #.*/--offline: ${P8};/" "$DISCORD_CSS"

    sed -i "s/--red-1: #.*/--red-1: ${P9};/" "$DISCORD_CSS"
    sed -i "s/--red-2: #.*/--red-2: ${P1};/" "$DISCORD_CSS"
    sed -i "s/--green-1: #.*/--green-1: ${P10};/" "$DISCORD_CSS"
    sed -i "s/--green-2: #.*/--green-2: ${P2};/" "$DISCORD_CSS"
    sed -i "s/--blue-1: #.*/--blue-1: ${P12};/" "$DISCORD_CSS"
    sed -i "s/--blue-2: #.*/--blue-2: ${CURSOR};/" "$DISCORD_CSS"
    sed -i "s/--blue-3: #.*/--blue-3: ${P4};/" "$DISCORD_CSS"
    sed -i "s/--yellow-1: #.*/--yellow-1: ${P11};/" "$DISCORD_CSS"
    sed -i "s/--yellow-2: #.*/--yellow-2: ${P3};/" "$DISCORD_CSS"
    sed -i "s/--purple-1: #.*/--purple-1: ${P5};/" "$DISCORD_CSS"
    sed -i "s/--purple-2: #.*/--purple-2: ${P5};/" "$DISCORD_CSS"

    # Update rgba values for hover states
    sed -i "s/--hover: rgba(.*/--hover: rgba(${CURSOR_RGB}, 0.15);/" "$DISCORD_CSS"
    sed -i "s/--active: rgba(.*/--active: rgba(${CURSOR_RGB}, 0.25);/" "$DISCORD_CSS"
    sed -i "s/--active-2: rgba(.*/--active-2: rgba(${CURSOR_RGB}, 0.35);/" "$DISCORD_CSS"
    sed -i "s/--border-light: rgba(.*/--border-light: rgba(${CURSOR_RGB}, 0.15);/" "$DISCORD_CSS"
    sed -i "s/--border: rgba(.*/--border: rgba(${CURSOR_RGB}, 0.3);/" "$DISCORD_CSS"

    UPDATED+=("Discord theme")
fi

# ============================================================
# STEP 3: Always generate the Zellij theme KDL
# ============================================================

# Ensure Zellij themes directory exists
mkdir -p "$ZELLIJ_THEME_DIR"

BG_DARK10=$(adjust_color "$BG" -10)
BG_LIGHT5=$(adjust_color "$BG" 5)
BG_LIGHT10=$(adjust_color "$BG" 10)
BG_LIGHT18=$(adjust_color "$BG" 18)
ACCENT_STRONG=$(adjust_color "$CURSOR" 8)
SEL_STRONG=$(adjust_color "$SEL_BG" 10)

cat > "$ZELLIJ_THEME_FILE" << EOF
themes {
    dankcolors {
        text_unselected {
            base $(hex_to_space_rgb "$FG")
            background $(hex_to_space_rgb "$BG_DARK10")
            emphasis_0 $(hex_to_space_rgb "$ACCENT_STRONG")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P7")
            emphasis_3 $(hex_to_space_rgb "$P8")
        }
        text_selected {
            base $(hex_to_space_rgb "$P15")
            background $(hex_to_space_rgb "$SEL_STRONG")
            emphasis_0 $(hex_to_space_rgb "$ACCENT_STRONG")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P14")
            emphasis_3 $(hex_to_space_rgb "$P12")
        }
        ribbon_unselected {
            base $(hex_to_space_rgb "$P15")
            background $(hex_to_space_rgb "$BG_LIGHT18")
            emphasis_0 $(hex_to_space_rgb "$P8")
            emphasis_1 $(hex_to_space_rgb "$P7")
            emphasis_2 $(hex_to_space_rgb "$P4")
            emphasis_3 $(hex_to_space_rgb "$P6")
        }
        ribbon_selected {
            base $(hex_to_space_rgb "$BG_DARK10")
            background $(hex_to_space_rgb "$ACCENT_STRONG")
            emphasis_0 $(hex_to_space_rgb "$BG_DARK10")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P3")
            emphasis_3 $(hex_to_space_rgb "$P12")
        }
        table_title {
            base $(hex_to_space_rgb "$BG_DARK10")
            background $(hex_to_space_rgb "$ACCENT_STRONG")
            emphasis_0 $(hex_to_space_rgb "$P15")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P3")
            emphasis_3 $(hex_to_space_rgb "$P4")
        }
        table_cell_unselected {
            base $(hex_to_space_rgb "$FG")
            background $(hex_to_space_rgb "$BG_DARK10")
            emphasis_0 $(hex_to_space_rgb "$P8")
            emphasis_1 $(hex_to_space_rgb "$P7")
            emphasis_2 $(hex_to_space_rgb "$P4")
            emphasis_3 $(hex_to_space_rgb "$P6")
        }
        table_cell_selected {
            base $(hex_to_space_rgb "$P15")
            background $(hex_to_space_rgb "$SEL_STRONG")
            emphasis_0 $(hex_to_space_rgb "$ACCENT_STRONG")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P14")
            emphasis_3 $(hex_to_space_rgb "$P12")
        }
        list_unselected {
            base $(hex_to_space_rgb "$FG")
            background $(hex_to_space_rgb "$BG_DARK10")
            emphasis_0 $(hex_to_space_rgb "$P8")
            emphasis_1 $(hex_to_space_rgb "$P7")
            emphasis_2 $(hex_to_space_rgb "$P4")
            emphasis_3 $(hex_to_space_rgb "$P6")
        }
        list_selected {
            base $(hex_to_space_rgb "$P15")
            background $(hex_to_space_rgb "$SEL_STRONG")
            emphasis_0 $(hex_to_space_rgb "$ACCENT_STRONG")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P14")
            emphasis_3 $(hex_to_space_rgb "$P12")
        }
        frame_unselected {
            base $(hex_to_space_rgb "$P8")
            background $(hex_to_space_rgb "$BG_DARK10")
            emphasis_0 $(hex_to_space_rgb "$BG_LIGHT18")
            emphasis_1 $(hex_to_space_rgb "$P7")
            emphasis_2 $(hex_to_space_rgb "$P4")
            emphasis_3 $(hex_to_space_rgb "$P6")
        }
        frame_selected {
            base $(hex_to_space_rgb "$ACCENT_STRONG")
            background $(hex_to_space_rgb "$BG_DARK10")
            emphasis_0 $(hex_to_space_rgb "$P15")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P3")
            emphasis_3 $(hex_to_space_rgb "$P12")
        }
        frame_highlight {
            base $(hex_to_space_rgb "$P3")
            background $(hex_to_space_rgb "$BG_DARK10")
            emphasis_0 $(hex_to_space_rgb "$ACCENT_STRONG")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P3")
            emphasis_3 $(hex_to_space_rgb "$P12")
        }
        exit_code_success {
            base $(hex_to_space_rgb "$P10")
            background $(hex_to_space_rgb "$BG_DARK10")
            emphasis_0 $(hex_to_space_rgb "$P10")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P2")
            emphasis_3 $(hex_to_space_rgb "$ACCENT_STRONG")
        }
        exit_code_error {
            base $(hex_to_space_rgb "$P9")
            background $(hex_to_space_rgb "$BG_DARK10")
            emphasis_0 $(hex_to_space_rgb "$P9")
            emphasis_1 $(hex_to_space_rgb "$P15")
            emphasis_2 $(hex_to_space_rgb "$P1")
            emphasis_3 $(hex_to_space_rgb "$ACCENT_STRONG")
        }
        multiplayer_user_colors {
            player_1 $(hex_to_space_rgb "$P1")
            player_2 $(hex_to_space_rgb "$P2")
            player_3 $(hex_to_space_rgb "$P3")
            player_4 $(hex_to_space_rgb "$P4")
            player_5 $(hex_to_space_rgb "$P5")
            player_6 $(hex_to_space_rgb "$P6")
            player_7 $(hex_to_space_rgb "$P12")
            player_8 $(hex_to_space_rgb "$P13")
            player_9 $(hex_to_space_rgb "$P14")
            player_10 $(hex_to_space_rgb "$P15")
        }
    }
}
EOF

sync_zellij_theme_block

UPDATED+=("Zellij theme")

# ============================================================
# STEP 4: Always generate the Lazygit theme config
# ============================================================

mkdir -p "$LAZYGIT_CONFIG_DIR"

cat > "$LAZYGIT_CONFIG_FILE" << EOF
gui:
  theme:
    activeBorderColor:
      - "$CURSOR"
      - bold
    inactiveBorderColor:
      - "$P8"
    searchingActiveBorderColor:
      - "$CURSOR"
      - bold
    optionsTextColor:
      - "$P4"
    selectedLineBgColor:
      - "$SEL_BG"
    inactiveViewSelectedLineBgColor:
      - "$P0"
    cherryPickedCommitFgColor:
      - "$P12"
    cherryPickedCommitBgColor:
      - "$CURSOR"
    markedBaseCommitFgColor:
      - "$BG"
    markedBaseCommitBgColor:
      - "$P3"
    unstagedChangesColor:
      - "$P1"
    defaultFgColor:
      - "$FG"
EOF

UPDATED+=("Lazygit theme")

# ============================================================
# STEP 5: Always generate the Zed theme JSON
# ============================================================

# Ensure Zed themes directory exists
mkdir -p "$ZED_THEME_DIR"

# Pre-compute adjusted colors
BG_LIGHT3=$(adjust_color "$BG" 3)
BG_LIGHT8=$(adjust_color "$BG" 8)
BG_LIGHT15=$(adjust_color "$BG" 15)

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

UPDATED+=("Zed theme")

# ============================================================
# STEP 6: Update Blender theme (warn if missing but don't exit)
# ============================================================

if [[ ! -f "$BLENDER_THEME_SCRIPT" ]]; then
    echo "Warning: Blender theme script not found at $BLENDER_THEME_SCRIPT (skipping Blender update)"
else
    if bash "$BLENDER_THEME_SCRIPT"; then
        UPDATED+=("Blender theme")
    else
        echo "Warning: Blender theme update failed"
    fi
fi

# ============================================================
# STEP 7: Output summary of what was updated
# ============================================================

echo ""
echo "=== Theme Colors Updated Successfully ==="

for item in "${UPDATED[@]}"; do
    echo "  - $item"
done

echo ""
echo "Theme colors used:"
echo "  Background: ${BG}"
echo "  Foreground: ${FG}"
echo "  Cursor: ${CURSOR}"
