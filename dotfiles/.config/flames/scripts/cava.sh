#!/bin/bash

COLORS_FILE="$HOME/.cache/wallust/colors"
CAVA_CONFIG="$HOME/.config/cava/config"

update_cava_colors() {
  color1=$(jq -r '.colors.color1' "$COLORS_FILE")
  color2=$(jq -r '.colors.color2' "$COLORS_FILE")
  color3=$(jq -r '.colors.color3' "$COLORS_FILE")
  color4=$(jq -r '.colors.color4' "$COLORS_FILE")
  color5=$(jq -r '.colors.color5' "$COLORS_FILE")
  color6=$(jq -r '.colors.color6' "$COLORS_FILE")
  color7=$(jq -r '.colors.color7' "$COLORS_FILE")
  color8=$(jq -r '.colors.color8' "$COLORS_FILE")

  sed -i "s/^gradient_color_1 = .*/gradient_color_1 = '$color1'/" "$CAVA_CONFIG"
  sed -i "s/^gradient_color_2 = .*/gradient_color_2 = '$color2'/" "$CAVA_CONFIG"
  sed -i "s/^gradient_color_3 = .*/gradient_color_3 = '$color3'/" "$CAVA_CONFIG"
  sed -i "s/^gradient_color_4 = .*/gradient_color_4 = '$color4'/" "$CAVA_CONFIG"
  sed -i "s/^gradient_color_5 = .*/gradient_color_5 = '$color5'/" "$CAVA_CONFIG"
  sed -i "s/^gradient_color_6 = .*/gradient_color_6 = '$color6'/" "$CAVA_CONFIG"
  sed -i "s/^gradient_color_7 = .*/gradient_color_7 = '$color7'/" "$CAVA_CONFIG"
  sed -i "s/^gradient_color_8 = .*/gradient_color_8 = '$color8'/" "$CAVA_CONFIG"

  pkill -SIGUSR2 cava   # ← reload INSIDE
}

# run once
update_cava_colors

# auto watch
inotifywait -m -e close_write "$COLORS_FILE" | while read; do
  update_cava_colors
done

