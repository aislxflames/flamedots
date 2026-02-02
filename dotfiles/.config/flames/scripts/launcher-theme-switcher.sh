#!/bin/bash

# Launcher Theme Switcher Script with Image Previews
# Location: ~/.config/flames/scripts/launcher-theme-switcher.sh

# Get image path from flamedots.rasi
IMAGE_PATH=$(grep "bg-image:" ~/.config/rofi/colors/flamedots.rasi | cut -d'"' -f2)
IMAGE_DIR=$(dirname "$IMAGE_PATH")
PREVIEW_DIR="$HOME/.config/flames/previews"

# Create preview images if they don't exist
create_previews() {
    # Type-5 previews with blue gradient
    convert -size 200x150 gradient:"#458588-#83A598" -pointsize 14 -fill "#EBDBB2" \
        -gravity center -annotate +0-10 "TYPE-5" -annotate +0+10 "STYLE-2" \
        -stroke "#282828" -strokewidth 1 "$PREVIEW_DIR/t5-s2.png" 2>/dev/null
    
    convert -size 200x150 gradient:"#B16286-#D3869B" -pointsize 14 -fill "#EBDBB2" \
        -gravity center -annotate +0-10 "TYPE-5" -annotate +0+10 "STYLE-5" \
        -stroke "#282828" -strokewidth 1 "$PREVIEW_DIR/t5-s5.png" 2>/dev/null
    
    convert -size 200x150 gradient:"#689D6A-#8EC07C" -pointsize 14 -fill "#EBDBB2" \
        -gravity center -annotate +0-10 "TYPE-5" -annotate +0+10 "STYLE-3" \
        -stroke "#282828" -strokewidth 1 "$PREVIEW_DIR/t5-s3.png" 2>/dev/null
    
    # Type-6 preview with yellow gradient
    convert -size 200x150 gradient:"#D79921-#FABD2F" -pointsize 14 -fill "#282828" \
        -gravity center -annotate +0-10 "TYPE-6" -annotate +0+10 "STYLE-1" \
        -stroke "#EBDBB2" -strokewidth 1 "$PREVIEW_DIR/t6-s1.png" 2>/dev/null
    
    # Type-7 previews with different color schemes
    colors=("#CC241D" "#98971A" "#D79921" "#458588" "#B16286" "#689D6A" "#A89984" "#928374" "#FB4934" "#B8BB26")
    
    for i in {1..10}; do
        color="${colors[$((i-1))]}"
        convert -size 200x150 gradient:"$color-#282828" -pointsize 14 -fill "#EBDBB2" \
            -gravity center -annotate +0-10 "TYPE-7" -annotate +0+10 "STYLE-$i" \
            -stroke "#282828" -strokewidth 1 "$PREVIEW_DIR/t7-s$i.png" 2>/dev/null
    done
}

# Create desktop entries for rofi
create_desktop_entries() {
    mkdir -p "$PREVIEW_DIR/desktop"
    
    cat > "$PREVIEW_DIR/desktop/t5-s2.desktop" << EOF
[Desktop Entry]
Name=T-5 S-2
Icon=$PREVIEW_DIR/t5-s2.png
Type=Application
EOF

    cat > "$PREVIEW_DIR/desktop/t5-s5.desktop" << EOF
[Desktop Entry]
Name=T-5 S-5
Icon=$PREVIEW_DIR/t5-s5.png
Type=Application
EOF

    cat > "$PREVIEW_DIR/desktop/t5-s3.desktop" << EOF
[Desktop Entry]
Name=T-5 S-3
Icon=$PREVIEW_DIR/t5-s3.png
Type=Application
EOF

    cat > "$PREVIEW_DIR/desktop/t6-s1.desktop" << EOF
[Desktop Entry]
Name=T-6 S-1
Icon=$PREVIEW_DIR/t6-s1.png
Type=Application
EOF

    for i in {1..10}; do
        cat > "$PREVIEW_DIR/desktop/t7-s$i.desktop" << EOF
[Desktop Entry]
Name=T-7 S-$i
Icon=$PREVIEW_DIR/t7-s$i.png
Type=Application
EOF
    done
}

# Theme mapping
declare -A THEMES=(
    ["T-5 S-2"]="type-5/style-2"
    ["T-5 S-5"]="type-5/style-5" 
    ["T-5 S-3"]="type-5/style-3"
    ["T-6 S-1"]="type-6/style-1"
    ["T-7 S-1"]="type-7/style-1"
    ["T-7 S-2"]="type-7/style-2"
    ["T-7 S-3"]="type-7/style-3"
    ["T-7 S-4"]="type-7/style-4"
    ["T-7 S-5"]="type-7/style-5"
    ["T-7 S-6"]="type-7/style-6"
    ["T-7 S-7"]="type-7/style-7"
    ["T-7 S-8"]="type-7/style-8"
    ["T-7 S-9"]="type-7/style-9"
    ["T-7 S-10"]="type-7/style-10"
)

# Create preview images and desktop entries
create_previews
create_desktop_entries

# Show rofi menu with custom theme
CHOICE=$(find "$PREVIEW_DIR/desktop" -name "*.desktop" -exec basename {} .desktop \; | \
    rofi -dmenu -i -p "Select Launcher Theme:" \
    -theme ~/.config/flames/theme-selector.rasi \
    -show-icons -icon-theme "Papirus")

# Exit if no choice made
[[ -z "$CHOICE" ]] && exit 0

# Get theme name from choice
THEME_NAME=$(grep "Name=" "$PREVIEW_DIR/desktop/$CHOICE.desktop" | cut -d'=' -f2)
THEME_PATH="${THEMES[$THEME_NAME]}"

# Apply theme function
apply_theme() {
    local theme_type=$(echo "$THEME_PATH" | cut -d'/' -f1)
    local theme_style=$(echo "$THEME_PATH" | cut -d'/' -f2)
    
    # Save current theme to config file
    echo "$THEME_PATH" > ~/.config/flames/current-theme
    
    notify-send "Launcher Theme Applied" "$THEME_NAME theme has been applied!" -t 2000
}

# Apply the selected theme
apply_theme

echo "Applied launcher theme: $THEME_NAME ($THEME_PATH)"
