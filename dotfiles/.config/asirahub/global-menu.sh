#!/bin/bash

TERMINAL="kitty"
RECENT_FILE="$HOME/.cache/asirahub_recent"

# Create recent file if it doesn't exist
touch "$RECENT_FILE"

# Read recent items (max 1)
recent_items=$(head -1 "$RECENT_FILE" 2>/dev/null | sed 's/^/󰋚  (Recent) /')

# Global search options - all available menu items
options="$recent_items
󰀻  Apps
󰑴  Learn
󰘦  Trigger
󰏘  Style
󰒓  Setup
󰏖  Install
󰆴  Remove
󰚰  Update
󰋽  About
󰏖  Official Package
󰏗  AUR
󰏔  Flatpak
󰖟  Web App
󰑮  Service
󰷈  Editor
󰅨  Development
󰊖  Gaming
󰇀  Mouse Cursor
󰒓  Hyprland Config
󰏘  GTK Theme
󰖟  Icon Theme
󰸌  Wallpaper
󰉼  Color Scheme
󰛖  Font Settings
󰍹  Terminal Theme"

chosen=$(echo -e "$options" | rofi -dmenu -i -p "Global Search" -theme ./menu-theme.rasi)

# Function to add to recent
add_to_recent() {
    local item="$1"
    # Remove if already exists
    grep -v "^$item$" "$RECENT_FILE" > "$RECENT_FILE.tmp" 2>/dev/null || true
    # Add to top
    echo "$item" > "$RECENT_FILE.new"
    head -0 "$RECENT_FILE.tmp" >> "$RECENT_FILE.new" 2>/dev/null || true
    mv "$RECENT_FILE.new" "$RECENT_FILE"
    rm -f "$RECENT_FILE.tmp"
}

case $chosen in
    *"(Recent)"*)
        # Extract original item name
        original_item=$(echo "$chosen" | sed 's/.*) //')
        chosen="$original_item"
        # Continue to regular case handling
        case $chosen in
            "󰀻  Apps")
                add_to_recent "󰀻  Apps"
                ./src/ui/apps.sh
                ;;
            "󰑴  Learn")
                add_to_recent "󰑴  Learn"
                ./src/ui/learn.sh
                ;;
            "󰘦  Trigger")
                add_to_recent "󰘦  Trigger"
                ./src/ui/trigger.sh
                ;;
            "󰏘  Style")
                add_to_recent "󰏘  Style"
                ./src/ui/style.sh "$TERMINAL"
                ;;
            "󰒓  Setup")
                add_to_recent "󰒓  Setup"
                ./src/ui/setup.sh
                ;;
            "󰏖  Install")
                add_to_recent "󰏖  Install"
                ./src/ui/install.sh "$TERMINAL"
                ;;
            "󰆴  Remove")
                add_to_recent "󰆴  Remove"
                ./src/ui/remove.sh "$TERMINAL"
                ;;
            "󰚰  Update")
                add_to_recent "󰚰  Update"
                ./src/ui/update.sh
                ;;
            "󰋽  About")
                add_to_recent "󰋽  About"
                ./src/ui/about.sh
                ;;
            "󰏖  Official Package")
                add_to_recent "󰏖  Official Package"
                $TERMINAL -e ./src/scripts/official-package.sh
                ;;
            "󰏗  AUR")
                add_to_recent "󰏗  AUR"
                $TERMINAL -e ./src/scripts/aur-package.sh
                ;;
            "󰏔  Flatpak")
                add_to_recent "󰏔  Flatpak"
                $TERMINAL -e ./src/scripts/flatpak-package.sh
                ;;
            "󰇀  Mouse Cursor")
                add_to_recent "󰇀  Mouse Cursor"
                ./src/scripts/mouse-cursor.sh
                ;;
            "󰒓  Hyprland Config")
                add_to_recent "󰒓  Hyprland Config"
                ./src/scripts/hypr-config.sh
                ;;
        esac
        ;;
    "󰀻  Apps")
        add_to_recent "󰀻  Apps"
        ./src/ui/apps.sh
        ;;
    "󰑴  Learn")
        add_to_recent "󰑴  Learn"
        ./src/ui/learn.sh
        ;;
    "󰘦  Trigger")
        add_to_recent "󰘦  Trigger"
        ./src/ui/trigger.sh
        ;;
    "󰏘  Style")
        add_to_recent "󰏘  Style"
        ./src/ui/style.sh "$TERMINAL"
        ;;
    "󰒓  Setup")
        add_to_recent "󰒓  Setup"
        ./src/ui/setup.sh
        ;;
    "󰏖  Install")
        add_to_recent "󰏖  Install"
        ./src/ui/install.sh "$TERMINAL"
        ;;
    "󰆴  Remove")
        add_to_recent "󰆴  Remove"
        ./src/ui/remove.sh "$TERMINAL"
        ;;
    "󰚰  Update")
        add_to_recent "󰚰  Update"
        ./src/ui/update.sh
        ;;
    "󰋽  About")
        add_to_recent "󰋽  About"
        ./src/ui/about.sh
        ;;
    # Global search direct actions
    "󰏖  Official Package")
        add_to_recent "󰏖  Official Package"
        $TERMINAL -e ./src/scripts/official-package.sh
        ;;
    "󰏗  AUR")
        add_to_recent "󰏗  AUR"
        $TERMINAL -e ./src/scripts/aur-package.sh
        ;;
    "󰏔  Flatpak")
        add_to_recent "󰏔  Flatpak"
        $TERMINAL -e ./src/scripts/flatpak-package.sh
        ;;
    "󰖟  Web App")
        add_to_recent "󰖟  Web App"
        $TERMINAL -e ./src/scripts/webapp.sh
        ;;
    "󰑮  Service"|"󰷈  Editor"|"󰅨  Development"|"󰊖  Gaming")
        add_to_recent "$chosen"
        echo "$chosen selected"
        ;;
    "󰇀  Mouse Cursor")
        add_to_recent "󰇀  Mouse Cursor"
        ./src/scripts/mouse-cursor.sh
        ;;
    "󰒓  Hyprland Config")
        add_to_recent "󰒓  Hyprland Config"
        ./src/scripts/hypr-config.sh
        ;;
    "󰏘  GTK Theme"|"󰖟  Icon Theme"|"󰸌  Wallpaper"|"󰉼  Color Scheme"|"󰛖  Font Settings"|"󰍹  Terminal Theme")
        add_to_recent "$chosen"
        echo "$chosen selected"
        ;;
esac
