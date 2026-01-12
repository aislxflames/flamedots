#!/bin/bash
# Style menu script

TERMINAL="$1"
RECENT_FILE="$HOME/.cache/asirahub_style_recent"

# Create recent file if it doesn't exist
touch "$RECENT_FILE"

# Read recent items (max 1)
recent_items=$(head -1 "$RECENT_FILE" 2>/dev/null | sed 's/^/󰋚  (Recent) /')

style_options="$recent_items
󰇀  Mouse Cursor
󰒓  Hyprland Config
󰏘  GTK Theme
󰖟  Icon Theme
󰸌  Wallpaper
󰉼  Color Scheme
󰛖  Font Settings
󰍹  Terminal Theme"

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

style_choice=$(echo -e "$style_options" | rofi -dmenu -i -p "Style" -theme ./menu-theme.rasi)

case $style_choice in
    *"(Recent)"*)
        # Extract original item name
        original_item=$(echo "$style_choice" | sed 's/.*) //')
        style_choice="$original_item"
        # Continue to regular case handling
        case $style_choice in
            "󰇀  Mouse Cursor")
                add_to_recent "󰇀  Mouse Cursor"
                ./src/scripts/mouse-cursor.sh
                ;;
            "󰒓  Hyprland Config")
                add_to_recent "󰒓  Hyprland Config"
                ./src/scripts/hypr-config.sh
                ;;
            "󰏘  GTK Theme")
                add_to_recent "󰏘  GTK Theme"
                echo "GTK Theme selected"
                ;;
            "󰖟  Icon Theme")
                add_to_recent "󰖟  Icon Theme"
                echo "Icon Theme selected"
                ;;
            "󰸌  Wallpaper")
                add_to_recent "󰸌  Wallpaper"
                echo "Wallpaper selected"
                ;;
            "󰉼  Color Scheme")
                add_to_recent "󰉼  Color Scheme"
                echo "Color Scheme selected"
                ;;
            "󰛖  Font Settings")
                add_to_recent "󰛖  Font Settings"
                echo "Font Settings selected"
                ;;
            "󰍹  Terminal Theme")
                add_to_recent "󰍹  Terminal Theme"
                echo "Terminal Theme selected"
                ;;
        esac
        ;;
    "󰇀  Mouse Cursor")
        add_to_recent "󰇀  Mouse Cursor"
        ./src/scripts/mouse-cursor.sh
        ;;
    "󰒓  Hyprland Config")
        add_to_recent "󰒓  Hyprland Config"
        ./src/scripts/hypr-config.sh
        ;;
    "󰏘  GTK Theme")
        add_to_recent "󰏘  GTK Theme"
        echo "GTK Theme selected"
        ;;
    "󰖟  Icon Theme")
        add_to_recent "󰖟  Icon Theme"
        echo "Icon Theme selected"
        ;;
    "󰸌  Wallpaper")
        add_to_recent "󰸌  Wallpaper"
        echo "Wallpaper selected"
        ;;
    "󰉼  Color Scheme")
        add_to_recent "󰉼  Color Scheme"
        echo "Color Scheme selected"
        ;;
    "󰛖  Font Settings")
        add_to_recent "󰛖  Font Settings"
        echo "Font Settings selected"
        ;;
    "󰍹  Terminal Theme")
        add_to_recent "󰍹  Terminal Theme"
        echo "Terminal Theme selected"
        ;;
esac
