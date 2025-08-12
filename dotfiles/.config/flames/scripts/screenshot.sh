#!/usr/bin/env bash
set -euo pipefail

TITLE="Flamedots Screenshot Manager"

CHOICE=$(printf "Fullscreen\nSpecific Part\nExtract Text" | rofi -dmenu -p "$TITLE")

case "$CHOICE" in
  "Fullscreen")
    sleep 0.2
    notify-send "Screenshot" "Fullscreen taken"
    grim - | swappy -f -
    ;;

  "Specific Part")
    sleep 0.2
    notify-send "Screenshot" "Select region"
    grim -g "$(slurp)" - | swappy -f -
    ;;

  "Extract Text")
    sleep 0.2
    notify-send "OCR" "Select area to extract text"
    GEOM="$(slurp)" || { notify-send "OCR" "Selection cancelled"; exit 0; }

    # Pipe screenshot → OCR → clipboard (no temp files)
    if grim -g "$GEOM" - | tesseract stdin stdout -l eng --dpi 200 | wl-copy; then
      notify-send "OCR Complete" "Text copied to clipboard"
    else
      notify-send "OCR Failed" "Check tesseract installation"
    fi
    ;;

  *)
    notify-send "Cancelled" "No valid choice"
    ;;
esac

