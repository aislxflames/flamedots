#!/bin/bash

# Define Colors
BOLD=$(tput bold)
CYAN=$(tput setaf 6)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Configuration Path
CONFIG_DIR="$HOME/.config/hypr/conf"

#Animation Files
CONFIG_ANIMATIONS="$HOME/.config/hypr/conf/animations"
CONFIG_DECORATIONS="$HOME/.config/hypr/conf/decorations"
CONFIG_WINDOWRULES="$HOME/.config/hypr/conf/windowrules"

# System Files
CONFIG_MONITORS="$HOME/.config/hypr/conf/monitors"

# Menu Options
main_options=("Appearance" "System" "SDDM (Coming Soon)" "Waybar (Coming Soon)" "EXIT")

appearance_options=("Animations" "Decorations" "Window Rules" "Wallpaper" "GTK Settings" "Back")
animations_options=($(ls "$CONFIG_ANIMATIONS"))
decorations_options=($(ls "$CONFIG_DECORATIONS"))
windowrules_options=($(ls "$CONFIG_WINDOWRULES"))

system_options=("Update System" "Monitors" "Window Rules" "Env" "Back")
monitors_options=($(ls "$CONFIG_MONITORS"))

editor_options=("nvim" "nano" "Back")
opration_options=("Execute" "Edit" "Back")

current_menu="main"
current_selection=0

# Function to draw header (Only runs once)
draw_header() {
    tput clear
    echo -e "${CYAN}You are here: / Settings${RESET}"
    echo -e "${BOLD}${YELLOW}
  ██████ ▓█████▄▄▄█████▓▄▄▄█████▓ ██▓ ███▄    █   ▄████   ██████
▒██    ▒ ▓█   ▀▓  ██▒ ▓▒▓  ██▒ ▓▒▓██▒ ██ ▀█   █  ██▒ ▀█▒▒██    ▒
░ ▓██▄   ▒███  ▒ ▓██░ ▒░▒ ▓██░ ▒░▒██▒▓██  ▀█ ██▒▒██░▄▄▄░░ ▓██▄
  ▒   ██▒▒▓█  ▄░ ▓██▓ ░ ░ ▓██▓ ░ ░██░▓██▒  ▐▌██▒░▓█  ██▓  ▒   ██▒
▒██████▒▒░▒████▒ ▒██▒ ░   ▒██▒ ░ ░██░▒██░   ▓██░░▒▓███▀▒▒██████▒▒
▒ ▒▓▒ ▒ ░░░ ▒░ ░ ▒ ░░     ▒ ░░   ░▓  ░ ▒░   ▒ ▒  ░▒   ▒ ▒ ▒▓▒ ▒ ░
░ ░▒  ░ ░ ░ ░  ░   ░        ░     ▒ ░░ ░░   ░ ▒░  ░   ░ ░ ░▒  ░ ░
░  ░  ░     ░    ░        ░       ▒ ░   ░   ░ ░ ░ ░   ░ ░  ░  ░
      ░     ░  ░                  ░           ░       ░       ░   
    ${RESET}" | lolcat
    echo -e "FlameOS Settings"
    echo -e "by Aislx Flames"
    echo -e "Version 1.0"
    echo -e "\n${CYAN}Use ↑ (Up) and ↓ (Down) to navigate, ENTER to select.${RESET}"
}
draw_appearance() {
    tput clear
    echo -e "${CYAN}You are here: / Settings${RESET}"
    echo -e "${BOLD}${YELLOW}
 ▄▄▄       ██▓███   ██▓███  ▓█████ ▄▄▄       ██▀███
▒████▄    ▓██░  ██▒▓██░  ██▒▓█   ▀▒████▄    ▓██ ▒ ██▒
▒██  ▀█▄  ▓██░ ██▓▒▓██░ ██▓▒▒███  ▒██  ▀█▄  ▓██ ░▄█ ▒
░██▄▄▄▄██ ▒██▄█▓▒ ▒▒██▄█▓▒ ▒▒▓█  ▄░██▄▄▄▄██ ▒██▀▀█▄
 ▓█   ▓██▒▒██▒ ░  ░▒██▒ ░  ░░▒████▒▓█   ▓██▒░██▓ ▒██▒
 ▒▒   ▓▒█░▒▓▒░ ░  ░▒▓▒░ ░  ░░░ ▒░ ░▒▒   ▓▒█░░ ▒▓ ░▒▓░
  ▒   ▒▒ ░░▒ ░     ░▒ ░      ░ ░  ░ ▒   ▒▒ ░  ░▒ ░ ▒░
  ░   ▒   ░░       ░░          ░    ░   ▒     ░░   ░
      ░  ░                     ░  ░     ░  ░   ░
    ${RESET}" | lolcat
    echo -e "\n${CYAN}Use ↑ (Up) and ↓ (Down) to navigate, ENTER to select.${RESET}"
}
draw_animations() {
    tput clear
    echo -e "${CYAN}You are here: / Settings${RESET}"
    echo -e "${BOLD}${YELLOW}
 ▄▄▄       ███▄    █  ██▓ ███▄ ▄███▓ ▄▄▄     ▄▄▄█████▓ ██▓ ▒█████   ███▄    █
▒████▄     ██ ▀█   █ ▓██▒▓██▒▀█▀ ██▒▒████▄   ▓  ██▒ ▓▒▓██▒▒██▒  ██▒ ██ ▀█   █
▒██  ▀█▄  ▓██  ▀█ ██▒▒██▒▓██    ▓██░▒██  ▀█▄ ▒ ▓██░ ▒░▒██▒▒██░  ██▒▓██  ▀█ ██▒
░██▄▄▄▄██ ▓██▒  ▐▌██▒░██░▒██    ▒██ ░██▄▄▄▄██░ ▓██▓ ░ ░██░▒██   ██░▓██▒  ▐▌██▒
 ▓█   ▓██▒▒██░   ▓██░░██░▒██▒   ░██▒ ▓█   ▓██▒ ▒██▒ ░ ░██░░ ████▓▒░▒██░   ▓██░
 ▒▒   ▓▒█░░ ▒░   ▒ ▒ ░▓  ░ ▒░   ░  ░ ▒▒   ▓▒█░ ▒ ░░   ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒
  ▒   ▒▒ ░░ ░░   ░ ▒░ ▒ ░░  ░      ░  ▒   ▒▒ ░   ░     ▒ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░
  ░   ▒      ░   ░ ░  ▒ ░░      ░     ░   ▒    ░       ▒ ░░ ░ ░ ▒     ░   ░ ░
      ░  ░         ░  ░         ░         ░  ░         ░      ░ ░           ░
    ${RESET}" | lolcat
    echo -e "\n${CYAN}Use ↑ (Up) and ↓ (Down) to navigate, ENTER to select.${RESET}"
}
draw_decorations() {
    tput clear
    echo -e "${CYAN}You are here: / Settings${RESET}"
    echo -e "${BOLD}${YELLOW}
▓█████▄ ▓█████  ▄████▄   ▒█████   ██▀███  ▄▄▄█████▓ ██▓ ▒█████   ███▄    █
▒██▀ ██▌▓█   ▀ ▒██▀ ▀█  ▒██▒  ██▒▓██ ▒ ██▒▓  ██▒ ▓▒▓██▒▒██▒  ██▒ ██ ▀█   █
░██   █▌▒███   ▒▓█    ▄ ▒██░  ██▒▓██ ░▄█ ▒▒ ▓██░ ▒░▒██▒▒██░  ██▒▓██  ▀█ ██▒
░▓█▄   ▌▒▓█  ▄ ▒▓▓▄ ▄██▒▒██   ██░▒██▀▀█▄  ░ ▓██▓ ░ ░██░▒██   ██░▓██▒  ▐▌██▒
░▒████▓ ░▒████▒▒ ▓███▀ ░░ ████▓▒░░██▓ ▒██▒  ▒██▒ ░ ░██░░ ████▓▒░▒██░   ▓██░
 ▒▒▓  ▒ ░░ ▒░ ░░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒▓ ░▒▓░  ▒ ░░   ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒
 ░ ▒  ▒  ░ ░  ░  ░  ▒     ░ ▒ ▒░   ░▒ ░ ▒░    ░     ▒ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░
 ░ ░  ░    ░   ░        ░ ░ ░ ▒    ░░   ░   ░       ▒ ░░ ░ ░ ▒     ░   ░ ░
   ░       ░  ░░ ░          ░ ░     ░               ░      ░ ░           ░
    ${RESET}" | lolcat
    echo -e "\n${CYAN}Use ↑ (Up) and ↓ (Down) to navigate, ENTER to select.${RESET}"
}
draw_windowrules() {
    tput clear
    echo -e "${CYAN}You are here: / Settings${RESET}"
    echo -e "${BOLD}${YELLOW}
 █     █░ ██▓ ███▄    █ ▓█████▄  ▒█████   █     █░ ██▀███   █    ██  ██▓
▓█░ █ ░█░▓██▒ ██ ▀█   █ ▒██▀ ██▌▒██▒  ██▒▓█░ █ ░█░▓██ ▒ ██▒ ██  ▓██▒▓██▒
▒█░ █ ░█ ▒██▒▓██  ▀█ ██▒░██   █▌▒██░  ██▒▒█░ █ ░█ ▓██ ░▄█ ▒▓██  ▒██░▒██░
░█░ █ ░█ ░██░▓██▒  ▐▌██▒░▓█▄   ▌▒██   ██░░█░ █ ░█ ▒██▀▀█▄  ▓▓█  ░██░▒██░
░░██▒██▓ ░██░▒██░   ▓██░░▒████▓ ░ ████▓▒░░░██▒██▓ ░██▓ ▒██▒▒▒█████▓ ░██████▒
░ ▓░▒ ▒  ░▓  ░ ▒░   ▒ ▒  ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▓░▒ ▒  ░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ░ ▒░▓  ░
  ▒ ░ ░   ▒ ░░ ░░   ░ ▒░ ░ ▒  ▒   ░ ▒ ▒░   ▒ ░ ░    ░▒ ░ ▒░░░▒░ ░ ░ ░ ░ ▒  ░
  ░   ░   ▒ ░   ░   ░ ░  ░ ░  ░ ░ ░ ░ ▒    ░   ░    ░░   ░  ░░░ ░ ░   ░ ░
    ░     ░           ░    ░        ░ ░      ░       ░        ░         ░  ░
    ${RESET}" | lolcat
    echo -e "\n${CYAN}Use ↑ (Up) and ↓ (Down) to navigate, ENTER to select.${RESET}"
}
draw_system() {
    tput clear
    echo -e "${CYAN}You are here: / Settings${RESET}"
    echo -e "${BOLD}${YELLOW}
  ██████▓██   ██▓  ██████ ▄▄▄█████▓▓█████  ███▄ ▄███▓
▒██    ▒ ▒██  ██▒▒██    ▒ ▓  ██▒ ▓▒▓█   ▀ ▓██▒▀█▀ ██▒
░ ▓██▄    ▒██ ██░░ ▓██▄   ▒ ▓██░ ▒░▒███   ▓██    ▓██░
  ▒   ██▒ ░ ▐██▓░  ▒   ██▒░ ▓██▓ ░ ▒▓█  ▄ ▒██    ▒██
▒██████▒▒ ░ ██▒▓░▒██████▒▒  ▒██▒ ░ ░▒████▒▒██▒   ░██▒
▒ ▒▓▒ ▒ ░  ██▒▒▒ ▒ ▒▓▒ ▒ ░  ▒ ░░   ░░ ▒░ ░░ ▒░   ░  ░
░ ░▒  ░ ░▓██ ░▒░ ░ ░▒  ░ ░    ░     ░ ░  ░░  ░      ░
░  ░  ░  ▒ ▒ ░░  ░  ░  ░    ░         ░   ░      ░
      ░  ░ ░           ░              ░  ░       ░
         ░ ░
    ${RESET}" | lolcat
    echo -e "\n${CYAN}Use ↑ (Up) and ↓ (Down) to navigate, ENTER to select.${RESET}"
}
draw_monitors() {
    tput clear
    echo -e "${CYAN}You are here: / Settings${RESET}"
    echo -e "${BOLD}${YELLOW}
 ███▄ ▄███▓ ▒█████   ███▄    █  ██▓▄▄▄█████▓ ▒█████   ██▀███    ██████
▓██▒▀█▀ ██▒▒██▒  ██▒ ██ ▀█   █ ▓██▒▓  ██▒ ▓▒▒██▒  ██▒▓██ ▒ ██▒▒██    ▒
▓██    ▓██░▒██░  ██▒▓██  ▀█ ██▒▒██▒▒ ▓██░ ▒░▒██░  ██▒▓██ ░▄█ ▒░ ▓██▄
▒██    ▒██ ▒██   ██░▓██▒  ▐▌██▒░██░░ ▓██▓ ░ ▒██   ██░▒██▀▀█▄    ▒   ██▒
▒██▒   ░██▒░ ████▓▒░▒██░   ▓██░░██░  ▒██▒ ░ ░ ████▓▒░░██▓ ▒██▒▒██████▒▒
░ ▒░   ░  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒ ░▓    ▒ ░░   ░ ▒░▒░▒░ ░ ▒▓ ░▒▓░▒ ▒▓▒ ▒ ░
░  ░      ░  ░ ▒ ▒░ ░ ░░   ░ ▒░ ▒ ░    ░      ░ ▒ ▒░   ░▒ ░ ▒░░ ░▒  ░ ░
░      ░   ░ ░ ░ ▒     ░   ░ ░  ▒ ░  ░      ░ ░ ░ ▒    ░░   ░ ░  ░  ░
       ░       ░ ░           ░  ░               ░ ░     ░           ░
    ${RESET}" | lolcat
    echo -e "\n${CYAN}Use ↑ (Up) and ↓ (Down) to navigate, ENTER to select.${RESET}"
}

# Function to draw menu
draw_menu() {
    local options=("${!1}")
    local menu_start_line=16
    for ((i = 0; i < ${#options[@]}; i++)); do
        tput cup $((menu_start_line + i)) 0
        echo -e "  ${GREEN}${options[$i]}${RESET}"
    done
}

# Function to update navigation bar
update_navbar() {
    local options=("${!1}")
    local menu_start_line=16
    for ((i = 0; i < ${#options[@]}; i++)); do
        tput cup $((menu_start_line + i)) 0
        tput el # Clear line
        if [[ $i -eq $current_selection ]]; then
            echo -e "➜ ${BOLD}${YELLOW}${options[$i]}${RESET}"
        else
            echo -e "  ${GREEN}${options[$i]}${RESET}"
        fi
    done
}

# Function to handle navigation
menu_navigation() {
    draw_header
    while true; do
        case $current_menu in
        main)
            options=("${main_options[@]}")
            draw_menu main_options[@]
            ;;
        appearance)
            options=("${appearance_options[@]}")
            draw_menu appearance_options[@]
            ;;
        animations)
            options=("${animations_options[@]}")
            draw_menu animations_options[@]
            ;;
        decorations)
            options=("${decorations_options[@]}")
            draw_menu decorations_options[@]
            ;;
        windowrules)
            options=("${windowrules_options[@]}")
            draw_menu windowrules_options[@]
            ;;

        system)
            options=("${system_options[@]}")
            draw_menu system_options[@]
            ;;
        monitors)
            options=("${monitors_options[@]}")
            draw_menu monitors_options[@]
            ;;
        oparation)
            options=("${opration_options[@]}")
            draw_menu opration_options[@]
            ;;
        editor)
            options=("${editor_options[@]}")
            draw_menu editor_options[@]
            ;;
        esac
        update_navbar options[@]

        read -rsn1 key
        case "$key" in
        $'\x1b')
            read -rsn2 -t 0.1 key2
            if [[ $key2 == "[A" ]]; then
                ((current_selection--))
                [[ $current_selection -lt 0 ]] && current_selection=$((${#options[@]} - 1))
            elif [[ $key2 == "[B" ]]; then
                ((current_selection++))
                [[ $current_selection -ge ${#options[@]} ]] && current_selection=0
            fi
            update_navbar options[@]
            ;;
        '') execute_selection ;;
        esac
    done
}

# Function to execute selection
execute_selection() {
    case $current_menu in
    main)
        case $current_selection in
        0)
            current_menu="appearance"
            draw_appearance
            ;;
        1)
            current_menu="system"
            draw_system
            ;;
        2 | 3) echo -e "${RED}Coming soon!${RESET}" && sleep 1 ;;
        4) exit_script ;;
        esac
        ;;
    appearance)
        case $current_selection in
        0)
            current_menu="animations"
            draw_animations
            ;;
        1)
            current_menu="decorations"
            draw_decorations
            ;;
        2)
            current_menu="windowrules"
            draw_windowrules
            ;;
        3)
            echo -e "Opening Wallpaper Settings"
            cd ~
            waypaper >/dev/null 2>&1
            ;;
        4)
            echo -e "Opening GTK Settings"
            nwg-look >/dev/null 2>&1
            ;;
        5)
            current_menu="main"
            draw_header
            ;;
        esac
        ;;
    animations)
        if [[ $current_selection -lt ${#animations_options[@]} ]]; then
            select_oparation "${animations_options[$current_selection]}" "$CONFIG_ANIMATIONS" "Animation"
        else
            current_menu="appearance"
            draw_appearance
        fi
        ;;
    decorations)
        if [[ $current_selection -lt ${#decorations_options[@]} ]]; then
            select_oparation "${decorations_options[$current_selection]}" "$CONFIG_DECORATIONS" "Decoration"
        else
            current_menu="appearance"
            draw_appearance
        fi
        ;;
    windowrules)
        if [[ $current_selection -lt ${#windowrules_options[@]} ]]; then
            select_oparation "${windowrules_options[$current_selection]}" "$CONFIG_WINDOWRULES" "WindowRules"
        else
            current_menu="appearance"
            draw_appearance
        fi
        ;;

    system)
        case $current_selection in
        0)
            sudo pacman -Suy
            tput clear
            echo "System Updated Successfully" &
            sleep 1
            draw_system
            ;;
        1)
            current_menu="monitors"
            draw_monitors
            ;;
        2)
            current_menu="windowrules"
            draw_windowrules
            ;;
        3)
            echo -e "Opening Wallpaper Settings"
            cd ~
            waypaper >/dev/null 2>&1
            ;;
        4)
            echo -e "Opening GTK Settings"
            nwg-look >/dev/null 2>&1
            ;;
        5)
            current_menu="main"
            draw_header
            ;;
        esac
        ;;
    monitors)
        if [[ $current_selection -lt ${#monitors_options[@]} ]]; then
            select_oparation "${monitors_options[$current_selection]}" "$CONFIG_MONITORS" "Monitors"
        else
            current_menu="appearance"
            draw_appearance
        fi
        ;;
    esac
    current_selection=0
    update_navbar options[@]
}

select_oparation() {
    local file_option="$2/$1"
    local custom_file="$2/custom-$1"

    if [[ ! -f "$file_option" ]]; then
        echo -e "${RED}File not found: $file_option${RESET}"
        sleep 2
        return
    fi

    local opration_options=("Execute" "Edit" "Delete" "Back")
    local selection=0

    while true; do
        tput cup $menu_start_line 16
        tput ed # Clear from cursor down

        echo -e "${CYAN}You are here: / Settings / $3 ${RESET}"
        echo -e "${BOLD}${YELLOW}Select an Operation for $1:${RESET}"

        for i in "${!opration_options[@]}"; do
            if [[ $i -eq $selection ]]; then
                echo -e "➜ ${BOLD}${YELLOW}${opration_options[$i]}${RESET}"
            else
                echo -e "  ${GREEN}${opration_options[$i]}${RESET}"
            fi
        done

        # Read user input
        read -rsn1 key
        case "$key" in
        $'\x1b')
            read -rsn2 -t 0.1 key2
            if [[ $key2 == "[A" ]]; then
                ((selection--))
                [[ $selection -lt 0 ]] && selection=$((${#opration_options[@]} - 1))
            elif [[ $key2 == "[B" ]]; then
                ((selection++))
                [[ $selection -ge ${#opration_options[@]} ]] && selection=0
            fi
            ;;
        '') # Enter key executes selection
            case $selection in
            0)
                sed -i "/^source =/c\source = $file_option" "$2.conf"
                echo -e "${GREEN}$3 applied: $file_option${RESET}"
                sleep 1
                return
                ;;
            1)
                if [[ "$(basename "$file_option")" == custom-* ]]; then
                    echo -e "Editing File"
                    nvim "$file_option"
                else
                    cp "$file_option" "$custom_file"
                    nvim "$custom_file"
                fi
                echo -e "${GREEN}Custom $3 saved: $custom_file${RESET}"
                sleep 1
                return
                ;;
            2)
                if [[ "$(basename "$file_option")" == custom-* ]]; then
                    rm -rf "$file_option"
                    echo -e "${GREEN}Custom $3 file deleted: $1${RESET}"
                else
                    echo -e "${YELLOW}You cannot delete a system file: $1${RESET}"
                fi
                sleep 1
                return
                ;;
            3) return ;; # Back to animations menu
            esac
            ;;
        esac
    done
}

# Exit Script
exit_script() {
    echo -e "${BOLD}${RED}Goodbye! 👋${RESET}"
    sleep 1
    tput clear
    exit 0
}

# Run the Menu
menu_navigation
