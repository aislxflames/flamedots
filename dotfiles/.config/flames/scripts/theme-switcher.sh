#!/bin/bash

# Icon paths
DARK_ICON="$HOME/.config/flames/icons/dark.png"
LIGHT_ICON="$HOME/.config/flames/icons/light.png"

# Rofi options with icons
OPTIONS=$"Dark\0icon\x1f$DARK_ICON\nLight\0icon\x1f$LIGHT_ICON\n"

# Show menu
SELECTED=$(echo -en "$OPTIONS" | rofi -dmenu -theme ~/.config/flames/rofi-themes/theme-switcher.rasi -p "Theme")

# Write selection to theme.sh
case "$SELECTED" in
  "Dark")
    echo "dark" > $HOME/.config/flames/scripts/theme.sh
    ~/.local/bin/walset-backend $HOME/.config/flames/wallpaper/dark/DarkPikachu.png
    ;;
  "Light")
    echo "light" > $HOME/.config/flames/scripts/theme.sh
    ~/.local/bin/walset-backend $HOME/.config/flames/wallpaper/light/cherry.jpg
    ;;
esac


