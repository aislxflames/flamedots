#!/usr/bin/env bash

if pgrep -x waybar > /dev/null; then
    # Waybar is running → kill all instances
    pkill -x waybar
else
    # Waybar is not running → start it via launch script
    ~/.config/waybar/launch.sh &
fi

