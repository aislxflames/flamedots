#!/bin/bash

options="󰈸  Pokemon
󰍛  SystemFetch"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Terminal Options" -theme ~/.config/asirahub/menu-theme.rasi)

case $chosen in
    "󰈸  Pokemon")
        sed -i '1s/.*/pokemon-colorscripts -r --no-title/' ~/.zshenv
        ;;
    "󰍛  SystemFetch")
        sed -i '1s/.*/fastfetch -c .config\/fastfetch\/startup.jsonc/' ~/.zshenv
        ;;
esac
