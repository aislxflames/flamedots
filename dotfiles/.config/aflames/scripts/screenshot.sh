
#!/bin/bash

# Title for the Rofi window
TITLE="Flamedots Screenshot Manager"


# Use Rofi to choose between fullscreen or specific part
CHOICE=$(echo -e "Fullscreen\nSpecific Part" | rofi -dmenu -p "$TITLE")

# Take screenshot based on the user's choice
if [[ "$CHOICE" == "Fullscreen" ]]; then
    notify-send "Screenshot of the screen taken" -t 1000 | grim - | swappy -f -
elif [[ "$CHOICE" == "Specific Part" ]]; then
  notify-send "Screenshot of the region taken" -t 1000 | grim -g "$(slurp)" - | swappy -f -
else
    echo "Invalid choice"
fi


