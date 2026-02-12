#!/bin/bash
# Enhanced mouse cursor selector script

update_gtk_settings() {
    local cursor_name="$1"
    local cursor_size="$2"
    
    # Update GTK-3.0 settings
    local gtk3_settings="$HOME/.config/gtk-3.0/settings.ini"
    if [ -f "$gtk3_settings" ]; then
        sed -i "s/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$cursor_name/" "$gtk3_settings"
        sed -i "s/^gtk-cursor-theme-size=.*/gtk-cursor-theme-size=$cursor_size/" "$gtk3_settings"
    fi
    
    # Update GTK-4.0 settings
    local gtk4_settings="$HOME/.config/gtk-4.0/settings.ini"
    if [ -f "$gtk4_settings" ]; then
        sed -i "s/^gtk-cursor-theme-name=.*/gtk-cursor-theme-name=$cursor_name/" "$gtk4_settings"
        sed -i "s/^gtk-cursor-theme-size=.*/gtk-cursor-theme-size=$cursor_size/" "$gtk4_settings"
    fi
}

# Find cursor themes
cursor_themes=""
for dir in "$HOME/.icons" "/usr/share/icons"; do
    if [ -d "$dir" ]; then
        for theme_dir in "$dir"/*; do
            if [ -d "$theme_dir/cursors" ]; then
                theme_name=$(basename "$theme_dir")
                cursor_themes="$cursor_themes$theme_name\n"
            fi
        done
    fi
done

cursor_themes=$(echo -e "$cursor_themes" | grep -v "^$" | sort -u)

if [ -z "$cursor_themes" ]; then
    notify-send "󰇀 Cursor Selector" "No cursor themes found"
    exit 1
fi

# Select cursor theme
selected_cursor=$(echo -e "$cursor_themes" | rofi -dmenu -i -p "󰇀 Select Cursor" -theme ./menu-theme.rasi)
[ -z "$selected_cursor" ] && exit 0

# Select cursor size
cursor_size=$(echo -e "16\n20\n24\n28\n32\n36\n48" | rofi -dmenu -i -p "󰇀 Cursor Size" -theme ./menu-theme.rasi)
[ -z "$cursor_size" ] && cursor_size=24

# Apply cursor
hyprctl setcursor "$selected_cursor" "$cursor_size" &

# Update configurations
autostart_conf="$HOME/.config/hypr/conf/autostart.conf"
mkdir -p "$(dirname "$autostart_conf")"

if [ -f "$autostart_conf" ]; then
    grep -v "exec-once = hyprctl setcursor" "$autostart_conf" > "$autostart_conf.tmp"
    mv "$autostart_conf.tmp" "$autostart_conf"
fi

echo "exec-once = hyprctl setcursor $selected_cursor $cursor_size" >> "$autostart_conf"

if ! grep -q "flatpak override --filesystem=~/.themes:ro --filesystem=~/.icons:ro --user" "$autostart_conf"; then
    echo "exec-once = flatpak override --filesystem=~/.themes:ro --filesystem=~/.icons:ro --user" >> "$autostart_conf"
fi

# Update GTK settings
update_gtk_settings "$selected_cursor" "$cursor_size"

# Apply flatpak override
flatpak override --filesystem=~/.themes:ro --filesystem=~/.icons:ro --user &

notify-send "󰇀 Cursor Applied" "Theme: $selected_cursor | Size: $cursor_size"
