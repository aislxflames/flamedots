#!/bin/bash
# Mouse cursor selector script

# Find cursor themes in ~/.icons/
cursor_themes=""
icons_dir="$HOME/.icons"

if [ -d "$icons_dir" ]; then
    for theme_dir in "$icons_dir"/*; do
        if [ -d "$theme_dir" ] && [ -d "$theme_dir/cursors" ] && [ -f "$theme_dir/index.theme" ]; then
            theme_name=$(basename "$theme_dir")
            cursor_themes="$cursor_themes$theme_name\n"
        fi
    done
fi

# Remove empty lines and sort
cursor_themes=$(echo -e "$cursor_themes" | grep -v "^$" | sort)

if [ -z "$cursor_themes" ]; then
    notify-send "󰇀 Cursor Selector" "No cursor themes found in ~/.icons/"
    exit 1
fi

selected_cursor=$(echo -e "$cursor_themes" | rofi -dmenu -i -p "󰇀 Select Cursor" -theme ./menu-theme.rasi)

if [ -n "$selected_cursor" ]; then
    hyprctl setcursor "$selected_cursor" 24 &
    
    # Update autostart.conf
    autostart_conf="$HOME/.config/hypr/conf/autostart.conf"
    if [ -f "$autostart_conf" ]; then
        # Remove existing cursor line and add new one
        grep -v "exec-once = hyprctl setcursor" "$autostart_conf" > "$autostart_conf.tmp"
        echo "exec-once = hyprctl setcursor $selected_cursor 24" >> "$autostart_conf.tmp"
        mv "$autostart_conf.tmp" "$autostart_conf"
    else
        # Create autostart.conf if it doesn't exist
        mkdir -p "$(dirname "$autostart_conf")"
        echo "exec-once = hyprctl setcursor $selected_cursor 24" > "$autostart_conf"
    fi
    
    # Add flatpak override to autostart if not exists
    if ! grep -q "flatpak override --filesystem=~/.themes:ro --filesystem=~/.icons:ro --user" "$autostart_conf"; then
        echo "exec-once = flatpak override --filesystem=~/.themes:ro --filesystem=~/.icons:ro --user" >> "$autostart_conf"
    fi
    
    # Run flatpak override command
    flatpak override --filesystem=~/.themes:ro --filesystem=~/.icons:ro --user &
    
    notify-send "󰇀 Cursor Applied" "Set cursor to: $selected_cursor (size 24)"
fi
