#!/bin/bash
# Remove menu script

TERMINAL="$1"

remove_options="󰏖  Package
󰖟  Web App"

remove_choice=$(echo -e "$remove_options" | rofi -dmenu -i -p "Remove" -theme ./menu-theme.rasi)

case $remove_choice in
    "󰏖  Package")
        $TERMINAL -e ./src/scripts/remove-package.sh
        ;;
    "󰖟  Web App")
        $TERMINAL -e ./src/scripts/remove-webapp.sh
        ;;
esac
