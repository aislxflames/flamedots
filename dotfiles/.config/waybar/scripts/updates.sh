#!/bin/bash

# Check for updates (pacman + AUR if using yay)
if ! command -v yay &> /dev/null; then
    updates=$(checkupdates 2> /dev/null | wc -l)
else
    updates=$(yay -Qua 2> /dev/null | wc -l)
fi

# Fallback if no updates command found
updates=${updates:-0}

# Output in JSON for Waybar
echo "{\"text\": \"$updates\", \"tooltip\": \"Available updates: $updates\"}"
