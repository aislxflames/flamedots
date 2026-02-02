#!/bin/bash

# Path to the wal colors file
COLORS_FILE="$HOME/.cache/wallust/colors"

# Path to the CAVA config file
CAVA_CONFIG="$HOME/.config/cava/config"

# Function to update CAVA with the new colors
update_cava_colors() {
  # Extract only dark colors (skip light ones)
  color1=$(sed -n '1p' "$COLORS_FILE")   # darkest
  color2=$(sed -n '13p' "$COLORS_FILE")  # dark
  color3=$(sed -n '5p' "$COLORS_FILE")   # mid-dark
  color4=$(sed -n '14p' "$COLORS_FILE")  # mid
  color5=$(sed -n '6p' "$COLORS_FILE")   # mid-light
  color6=$(sed -n '15p' "$COLORS_FILE")  # lighter
  color7=$(sed -n '8p' "$COLORS_FILE")   # light
  color8=$(sed -n '10p' "$COLORS_FILE")  # lightest (no white)

  # Update the CAVA config with the new colors
  sed -i "s/gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$CAVA_CONFIG"
  sed -i "s/gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$CAVA_CONFIG"
  sed -i "s/gradient_color_3 = .*/gradient_color_3 = '$color3'/" "$CAVA_CONFIG"
  sed -i "s/gradient_color_4 = .*/gradient_color_4 = '$color4'/" "$CAVA_CONFIG"
  sed -i "s/gradient_color_5 = .*/gradient_color_5 = '$color5'/" "$CAVA_CONFIG"
  sed -i "s/gradient_color_6 = .*/gradient_color_6 = '$color6'/" "$CAVA_CONFIG"
  sed -i "s/gradient_color_7 = .*/gradient_color_7 = '$color7'/" "$CAVA_CONFIG"
  sed -i "s/gradient_color_8 = .*/gradient_color_8 = '$color8'/" "$CAVA_CONFIG"

  # Kill all running instances of cava
  pkill -SIGUSR2 cava

  # Find all TTYs where cava was running and restart cava in those terminals
  for tty in $(ps aux | grep '[c]ava' | awk '{print $7}' | sort -u); do
    if [ -n "$tty" ]; then
      # Send the cava start command to each terminal's TTY
      echo "Starting cava in $tty"
      ttyname=$(ps -p $$ -o tty=)
      if [ "$ttyname" == "$tty" ]; then
        # This is the terminal we are running in, start cava in the current terminal
        cava &
      else
        # Otherwise, send the start command to the specified tty
        screen -S cava-session -X stuff "cava\n"
        # You can use `tmux` or `tty` for other approaches depending on how you manage terminals.
      fi
    fi
  done
}

# Monitor the colors file for changes
#inotifywait -m -e close_write "$COLORS_FILE" | while read path action file; do
  update_cava_colors
#done
