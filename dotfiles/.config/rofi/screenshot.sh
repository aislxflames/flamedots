#!/bin/bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots/flameshots.png"
RECORD_DIR="$HOME/Videos/Recordings"
PID_FILE="/tmp/wf-recorder.pid"

mkdir -p "$SCREENSHOT_DIR" "$RECORD_DIR"

options="󰹑 Full Screen
󰩭 Select Area
󰖲 Current Window
󰄀 Delayed (5s)
󰸶 Screen Record (Full)
󰸶 Screen Record (Area)
󰏌 Stop Recording"

selected=$(echo -e "$options" | rofi -dmenu -p "Capture")

case "$selected" in
  "󰹑 Full Screen")
    sleep 0.5
    grim - | satty -f - -o $SCREENSHOT_DIR
    ;;

  "󰩭 Select Area")
    sleep 0.5
    grim -g "$(slurp)" - | satty -f -
    ;;

  "󰖲 Current Window")
    sleep 0.5
    grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | satty -f -
    ;;

  "󰄀 Delayed (5s)")
    notify-send "Screenshot" "Taking screenshot in 5 seconds…"
    sleep 5
    grim - | satty -f -
    ;;

  "󰸶 Screen Record (Full)")
    if [ -f "$PID_FILE" ]; then
      notify-send "Screen Record" "Recording already running"
      exit 0
    fi

    FILE="$RECORD_DIR/record_$(date +%Y%m%d_%H%M%S).mp4"
    wf-recorder -f "$FILE" --audio &
    echo $! > "$PID_FILE"
    notify-send "Screen Record" "Recording started (Full screen)"
    ;;

  "󰸶 Screen Record (Area)")
    if [ -f "$PID_FILE" ]; then
      notify-send "Screen Record" "Recording already running"
      exit 0
    fi

    GEOM=$(slurp)
    FILE="$RECORD_DIR/record_$(date +%Y%m%d_%H%M%S).mp4"
    wf-recorder -g "$GEOM" -f "$FILE" --audio &
    echo $! > "$PID_FILE"
    notify-send "Screen Record" "Recording started (Area)"
    ;;

  "󰏌 Stop Recording")
    if [ -f "$PID_FILE" ]; then
      kill "$(cat "$PID_FILE")"
      rm -f "$PID_FILE"
      notify-send "Screen Record" "Recording stopped"
    else
      notify-send "Screen Record" "No active recording"
    fi
    ;;
esac

