#!/bin/bash

#!/bin/bash

# Path to the rofi launchers directory
LAUNCHERS_DIR="$HOME/.config/rofi/powermenu"

# Get the list of folder names
launcher_options=$(find "$LAUNCHERS_DIR" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)

# Use rofi to present the options
chosen_launcher=$(echo "$launcher_options" | rofi -dmenu -p "Select Rofi Launcher Theme")

# Exit if nothing is selected
[ -z "$chosen_launcher" ] && exit 1

# Create the launcher-theme.sh file
cat > $HOME/.config/rofi/powermenu-theme.sh <<EOF
#!/bin/bash
# Launch rofi using the selected launcher theme
"$LAUNCHERS_DIR/$chosen_launcher/powermenu.sh"
EOF

# Make the new script executable
chmod +x ./pwoermenu-theme.sh

