#!/bin/bash
#
# update-discord-colors.sh
# Updates Discord theme colors from ghostty dankcolors theme
# Add this to your Dank Hook to auto-update when matugen regenerates colors
#

GHOSTTY_THEME="$HOME/.config/ghostty/themes/dankcolors"
DISCORD_CSS="$HOME/.var/app/com.discordapp.Discord/config/Vencord/themes/dankcolors-discord.css"

if [[ ! -f "$GHOSTTY_THEME" ]]; then
    echo "Error: Ghostty theme not found at $GHOSTTY_THEME"
    exit 1
fi

if [[ ! -f "$DISCORD_CSS" ]]; then
    echo "Error: Discord CSS not found at $DISCORD_CSS"
    exit 1
fi

# Extract colors from ghostty theme
BG=$(grep "^background = " "$GHOSTTY_THEME" | sed 's/background = //')
FG=$(grep "^foreground = " "$GHOSTTY_THEME" | sed 's/foreground = //')
CURSOR=$(grep "^cursor-color = " "$GHOSTTY_THEME" | sed 's/cursor-color = //')
SEL_BG=$(grep "^selection-background = " "$GHOSTTY_THEME" | sed 's/selection-background = //')

# Extract palette colors
P0=$(grep "^palette = 0=" "$GHOSTTY_THEME" | sed 's/palette = 0=//')
P1=$(grep "^palette = 1=" "$GHOSTTY_THEME" | sed 's/palette = 1=//')
P2=$(grep "^palette = 2=" "$GHOSTTY_THEME" | sed 's/palette = 2=//')
P3=$(grep "^palette = 3=" "$GHOSTTY_THEME" | sed 's/palette = 3=//')
P4=$(grep "^palette = 4=" "$GHOSTTY_THEME" | sed 's/palette = 4=//')
P5=$(grep "^palette = 5=" "$GHOSTTY_THEME" | sed 's/palette = 5=//')
P6=$(grep "^palette = 6=" "$GHOSTTY_THEME" | sed 's/palette = 6=//')
P7=$(grep "^palette = 7=" "$GHOSTTY_THEME" | sed 's/palette = 7=//')
P8=$(grep "^palette = 8=" "$GHOSTTY_THEME" | sed 's/palette = 8=//')
P9=$(grep "^palette = 9=" "$GHOSTTY_THEME" | sed 's/palette = 9=//')
P10=$(grep "^palette = 10=" "$GHOSTTY_THEME" | sed 's/palette = 10=//')
P11=$(grep "^palette = 11=" "$GHOSTTY_THEME" | sed 's/palette = 11=//')
P12=$(grep "^palette = 12=" "$GHOSTTY_THEME" | sed 's/palette = 12=//')
P13=$(grep "^palette = 13=" "$GHOSTTY_THEME" | sed 's/palette = 13=//')
P14=$(grep "^palette = 14=" "$GHOSTTY_THEME" | sed 's/palette = 14=//')
P15=$(grep "^palette = 15=" "$GHOSTTY_THEME" | sed 's/palette = 15=//')

# Convert hex to RGB for rgba
hex_to_rgb() {
    local hex="${1#\#}"
    printf "%d, %d, %d" 0x${hex:0:2} 0x${hex:2:2} 0x${hex:4:2}
}

CURSOR_RGB=$(hex_to_rgb "$CURSOR")

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

echo "Discord theme updated successfully!"
echo "Background: ${BG}"
echo "Foreground: ${FG}"
echo "Cursor: ${CURSOR}"
