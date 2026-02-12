#!/bin/bash
# Cursor Manager - Advanced cursor configuration utility

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

backup_settings() {
    local backup_dir="$HOME/.config/asirahub/backups/$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    [ -f "$HOME/.config/gtk-3.0/settings.ini" ] && cp "$HOME/.config/gtk-3.0/settings.ini" "$backup_dir/gtk3-settings.ini"
    [ -f "$HOME/.config/gtk-4.0/settings.ini" ] && cp "$HOME/.config/gtk-4.0/settings.ini" "$backup_dir/gtk4-settings.ini"
    [ -f "$HOME/.config/hypr/conf/autostart.conf" ] && cp "$HOME/.config/hypr/conf/autostart.conf" "$backup_dir/autostart.conf"
    
    echo "$backup_dir"
}

restore_settings() {
    local backup_dir="$1"
    [ ! -d "$backup_dir" ] && { echo "Backup directory not found"; return 1; }
    
    [ -f "$backup_dir/gtk3-settings.ini" ] && cp "$backup_dir/gtk3-settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
    [ -f "$backup_dir/gtk4-settings.ini" ] && cp "$backup_dir/gtk4-settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
    [ -f "$backup_dir/autostart.conf" ] && cp "$backup_dir/autostart.conf" "$HOME/.config/hypr/conf/autostart.conf"
}

case "$1" in
    "backup")
        backup_dir=$(backup_settings)
        notify-send "󰇀 Cursor Manager" "Settings backed up to: $backup_dir"
        ;;
    "restore")
        if [ -n "$2" ]; then
            restore_settings "$2"
            notify-send "󰇀 Cursor Manager" "Settings restored from: $2"
        else
            echo "Usage: $0 restore <backup_directory>"
        fi
        ;;
    *)
        exec "$SCRIPT_DIR/mouse-cursor.sh"
        ;;
esac
