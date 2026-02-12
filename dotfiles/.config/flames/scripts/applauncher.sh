#!/bin/bash

# App Launcher Script
# Location: ~/.config/flames/scripts/applauncher.sh

# Get current theme from config file or default
THEME_FILE="$HOME/.config/flames/current-theme"
if [[ -f "$THEME_FILE" ]]; then
    CURRENT_THEME=$(cat "$THEME_FILE")
else
    CURRENT_THEME="type-3/style-4"
fi

# Launch rofi with current theme
rofi -show drun -theme ~/.config/rofi/launchers/$CURRENT_THEME.rasi
