#!/bin/bash
# Install submenu script

TERMINAL="$1"

install_options="󰏖  Official Package
󰏗  AUR
󰖟  Web App
󰑮  Service
󰷈  Editor
󰅨  Development
󰊖  Gaming
󰏔  Flatpak"

install_choice=$(echo -e "$install_options" | rofi -dmenu -i -p "Install" -theme ./menu-theme.rasi)

case $install_choice in
    "󰏖  Official Package")
        $TERMINAL -e ./src/scripts/official-package.sh
        ;;
    "󰏗  AUR")
        $TERMINAL -e ./src/scripts/aur-package.sh
        ;;
    "󰖟  Web App")
        $TERMINAL -e ./src/scripts/webapp.sh
        ;;
    "󰑮  Service")
        echo "Service selected"
        ;;
    "󰷈  Editor")
        echo "Editor selected"
        ;;
    "󰅨  Development")
        echo "Development selected"
        ;;
    "󰊖  Gaming")
        echo "Gaming selected"
        ;;
    "󰏔  Flatpak")
        $TERMINAL -e ./src/scripts/flatpak-package.sh
        ;;
esac
