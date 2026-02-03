#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

options="󰹑 Full Screen\n󰩭 Select Area\n󰖲 Current Window\n󰄀 Delayed (5s)\n󰸶 Screen Record\n󰏌 Stop Recording"

selected=$(echo -e "$options" | rofi -dmenu -p "Screenshot")

case "$selected" in
    "󰹑 Full Screen")
        sleep 0.2
        grim "$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"
        notify-send "Screenshot" "Full screen captured"
        ;;
    "󰩭 Select Area")
        sleep 0.2
        grim -g "$(slurp)" "$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"
        notify-send "Screenshot" "Area captured"
        ;;
    "󰖲 Current Window")
        sleep 0.2
        grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"
        notify-send "Screenshot" "Window captured"
        ;;
    "󰄀 Delayed (5s)")
        notify-send "Screenshot" "Taking screenshot in 5 seconds..."
        sleep 5
        sleep 0.1
        grim "$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"
        notify-send "Screenshot" "Delayed screenshot captured"
        ;;
    "󰸶 Screen Record")
        wf-recorder -f "$SCREENSHOT_DIR/recording_$(date +%Y%m%d_%H%M%S).mp4" &
        echo $! > /tmp/wf-recorder.pid
        notify-send "Screen Record" "Recording started"
        ;;
    "󰏌 Stop Recording")
        if [ -f /tmp/wf-recorder.pid ]; then
            kill $(cat /tmp/wf-recorder.pid)
            rm /tmp/wf-recorder.pid
            notify-send "Screen Record" "Recording stopped"
        else
            notify-send "Screen Record" "No recording in progress"
        fi
        ;;
esac
