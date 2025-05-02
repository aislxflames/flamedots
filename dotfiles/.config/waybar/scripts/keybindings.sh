#!/bin/bash
#  _              _     _           _ _
# | | _____ _   _| |__ (_)_ __   __| (_)_ __   __ _ ___
# | |/ / _ \ | | | '_ \| | '_ \ / _` | | '_ \ / _` / __|
# |   <  __/ |_| | |_) | | | | | (_| | | | | | (_| \__ \
# |_|\_\___|\__, |_.__/|_|_| |_|\__,_|_|_| |_|\__, |___/
#           |___/                             |___/

# -----------------------------------------------------
# Use actual path to keybindings config file
# -----------------------------------------------------
config_file="$HOME/.config/hypr/conf/keybinds.conf"

# -----------------------------------------------------
# Show where we are reading from
# -----------------------------------------------------
echo "reading from: $config_file"

# Parse binds: bind, bindel, bindm, etc.
keybinds=$(grep -E '^bind' "$config_file" | while IFS=',' read -r type mod key action rest; do
    # Replace $mainMod with SUPER
    mod=${mod//\$mainMod/SUPER}
    key=${key// /}
    action=${action// /}
    cmd="${action} ${rest}"
    printf "%-25s → %s\n" "$mod + $key" "$cmd"
done)

# Show in rofi
sleep 0.2
echo "$keybinds" | rofi -dmenu -theme gruvbox-dark -i -markup -eh 2 -replace -p "keybinds"
