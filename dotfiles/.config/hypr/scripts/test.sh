#!/bin/bash

# Directory where wallpapers are stored
WALLPAPER_DIR="$HOME/wallpapers"

# Get a list of image files
wallpapers=($(find "$WALLPAPER_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \)))

# If no wallpapers are found, exit
[ ${#wallpapers[@]} -eq 0 ] && notify-send "No wallpapers found!" && exit 1

# Prepare list with icons for Rofi
wallpaper_list=""
for wp in "${wallpapers[@]}"; do
    wallpaper_list+="<img>$wp</img> $(basename "$wp")\n"
done

# Show Rofi menu with preview (Dave's fullscreen mode)
selected=$(echo -e "$wallpaper_list" | rofi -dmenu -i -markup-rows -p "Select Wallpaper" -theme-str 'window {width: 50%;}')

# Extract the selected filename
selected_file=$(echo "$selected" | awk '{print $NF}')

# Exit if no selection is made
[ -z "$selected_file" ] && exit 1

# Get the full path of the selected wallpaper
selected_path="$WALLPAPER_DIR/$selected_file"

# Preview the wallpaper in fullscreen using `dave`
dave "$selected_path" &

# Ask user if they want to set it
confirm=$(echo -e "Yes\nNo" | rofi -dmenu -i -p "Set as wallpaper?")

# Kill the preview
pkill dave

if [[ "$confirm" == "Yes" ]]; then
    swww img "$selected_path" --transition-type=outer --transition-duration=1
    notify-send "Wallpaper Set!" "$selected_path"
fi

