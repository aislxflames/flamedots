#!/bin/sh

# Read the theme name from the file
theme=$(cat ~/.config/waybar/theme.sh)

# Set the FILEPATH variable
FILEPATH="$HOME/.config/waybar/themes/$theme"

    killall waybar
    waybar -c "$FILEPATH/config.jsonc" -s "$FILEPATH/style.css" & disown
