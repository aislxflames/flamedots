#!/bin/bash

STATE_FILE="/tmp/hypr_focus_mode"

if [ -f "$STATE_FILE" ]; then
    # Exit focus mode - reload Hyprland
    rm "$STATE_FILE"
    hyprctl reload
    notify-send "Focus Mode" "Disabled"
else
    # Enter focus mode - minimal distractions
    hyprctl keyword decoration:active_opacity 1.0
    hyprctl keyword decoration:inactive_opacity 1.0
    hyprctl keyword decoration:drop_shadow false
    hyprctl keyword decoration:rounding 0
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
    hyprctl keyword general:border_size 0
    touch "$STATE_FILE"
    notify-send "Focus Mode" "Enabled"
fi
