#!/bin/bash
# Trigger script - file browser and command runner

TERMINAL="kitty"

# Start from home directory
cd "$HOME"

while true; do
    # Get current directory contents and add command option
    current_dir=$(pwd)
    options="󰘦  Run Command
󰁞  Go Up (..)
$(find . -maxdepth 1 -type d -name ".*" -prune -o -type d -print | sed 's|^\./||' | grep -v "^\.$" | sort | sed 's/^/󰉋  /')
$(find . -maxdepth 1 -type f -name ".*" -prune -o -type f -print | sed 's|^\./||' | sort | while read file; do
    if [ -n "$file" ]; then
        file_type=$(file -b --mime-type "$file" 2>/dev/null)
        case "$file_type" in
            image/*) echo "󰋩  $file" ;;
            text/*|application/json|application/xml) echo "󰈙  $file" ;;
            application/pdf) echo "󰈦  $file" ;;
            audio/*) echo "󰝚  $file" ;;
            video/*) echo "󰕧  $file" ;;
            application/zip|application/x-tar|application/gzip) echo "󰗄  $file" ;;
            *) echo "󰈔  $file" ;;
        esac
    fi
done)"
    
    choice=$(echo -e "$options" | rofi -dmenu -i -p "Trigger: $(basename "$current_dir")" -theme /run/media/devhub/Experiments/asirahub/menu-theme.rasi)
    
    if [ -z "$choice" ]; then
        break
    fi
    
    # Remove icon from choice
    clean_choice=$(echo "$choice" | sed 's/^󰘦  //; s/^󰁞  //; s/^󰉋  //; s/^󰈙  //; s/^󰋩  //; s/^󰈦  //; s/^󰝚  //; s/^󰕧  //; s/^󰗄  //; s/^󰈔  //')
    
    case "$choice" in
        "󰘦  Run Command")
            command=$(echo "" | rofi -dmenu -i -p "Enter Command" -theme /run/media/devhub/Experiments/asirahub/menu-theme.rasi)
            if [ -n "$command" ]; then
                $TERMINAL -e bash -c "$command; read -p 'Press Enter to continue...'"
            fi
            ;;
        "󰁞  Go Up (..)")
            cd ..
            ;;
        "󰉋  "*)
            if [ -d "$clean_choice" ]; then
                cd "$clean_choice"
            fi
            ;;
        *)
            if [ -f "$clean_choice" ]; then
                # Check file type and open accordingly
                file_type=$(file -b --mime-type "$clean_choice")
                case "$file_type" in
                    image/*)
                        # Open image with default viewer
                        xdg-open "$clean_choice" &
                        ;;
                    text/*|application/json|application/xml)
                        # Open text files in terminal editor
                        $TERMINAL -e nano "$clean_choice"
                        ;;
                    *)
                        # Try to open with default application
                        xdg-open "$clean_choice" &
                        ;;
                esac
            fi
            ;;
    esac
done
