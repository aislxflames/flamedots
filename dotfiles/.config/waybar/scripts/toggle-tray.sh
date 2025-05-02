#!/bin/bash
STATE_FILE="/tmp/waybar_tray_toggle"

if [[ -f "$STATE_FILE" ]]; then
    rm "$STATE_FILE"
else
    touch "$STATE_FILE"
fi

# Reload waybar class via SIGUSR1 to apply style changes
pkill -SIGRTMIN+8 waybar
