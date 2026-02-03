#!/bin/bash

selection=$(printf "󱎘 Clear History\n$(cliphist list)" | rofi -dmenu -p "Clipboard")

if [[ "$selection" == "󱎘 Clear History" ]]; then
    cliphist wipe
    rm -f ~/.cache/cliphist/db
    notify-send "Clipboard" "History cleared"
elif [[ -n "$selection" ]]; then
    echo "$selection" | cliphist decode | wl-copy
fi
