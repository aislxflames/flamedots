#!/bin/sh

THEMES_DIR="$HOME/.config/waybar/themes"
THEME_FILE="$HOME/.config/waybar/theme.sh"
LAUNCH_SCRIPT="$HOME/.config/waybar/launch.sh"

# Get selected theme using Rofi
theme=$(ls "$THEMES_DIR" | rofi -dmenu -p "Select a theme")

# Check if a theme was selected
if [ -n "$theme" ]; then
    # Update the theme.sh file
    echo "$theme" > "$THEME_FILE"
    echo "Theme switched to $theme"

    # Ensure the launch script exists before executing
    if [ -x "$LAUNCH_SCRIPT" ]; then
        "$LAUNCH_SCRIPT" > /dev/null 2>&1 &
    else
        echo "Error: Launch script not found or not executable!"
    fi
else
    echo "No theme selected!"
fi

