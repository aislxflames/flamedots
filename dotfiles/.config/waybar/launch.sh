#!/bin/sh

# Read the theme name from the file
theme=$(cat ~/.config/waybar/theme.sh)

# Set the FILEPATH variable
FILEPATH="$HOME/.config/waybar/themes/$theme"

# Run Waybar with the specified config and style
killall waybar
waybar -c "$FILEPATH/config" -s "$FILEPATH/style.css" & disown
