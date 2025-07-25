#!/bin/bash

WALLPAPER_DIR="$HOME/.config/flames/wallpaper"
SCRIPT_DIR="$HOME/.config/flames/scripts"
ROFI_THEME="$HOME/.config/flames/rofi-themes/theme-switcher.rasi"

# Build rofi options
OPTIONS=""
THEME_MAP=()  # Indexed array to map display text back to folder

while IFS= read -r -d '' THEME_FOLDER; do
  THEME_NAME=$(basename "$THEME_FOLDER")
  ICON_PATH="$THEME_FOLDER/current.png"

  # Only show if current.png exists
  if [[ -f "$ICON_PATH" ]]; then
    OPTIONS+="$THEME_NAME\0icon\x1f$ICON_PATH\n"
    THEME_MAP+=("$THEME_NAME")
  fi
done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type d -name "dark-*" -print0 -o -name "light-*" -print0)

# Launch rofi
SELECTED=$(echo -en "$OPTIONS" | rofi -dmenu -theme "$ROFI_THEME" -p "Choose Theme")

# If user made a selection
if [[ -n "$SELECTED" ]]; then
  THEME_DIR="$WALLPAPER_DIR/$SELECTED"

  # Determine type
  if [[ "$SELECTED" == dark-* ]]; then
    echo "dark" > "$SCRIPT_DIR/theme.sh"
  elif [[ "$SELECTED" == light-* ]]; then
    echo "light" > "$SCRIPT_DIR/theme.sh"
  fi

  # Also write selected folder name to theme-path.sh
  echo "$SELECTED" > "$SCRIPT_DIR/theme-path.sh"

  # Set wallpaper (you can modify the default wallpaper filename here)
  if [[ -f "$THEME_DIR/current.png" ]]; then
    ~/.local/bin/walset-backend "$THEME_DIR/current.png"
  else
    notify-send "Theme Switcher" "Wallpaper not found in $THEME_DIR"
  fi
fi

