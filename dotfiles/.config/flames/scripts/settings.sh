#!/bin/bash

export FZF_DEFAULT_OPTS="
  --reverse
  --height=40%
  --layout=reverse
  --border=none
  --margin=1,10
  --color=spinner:#f38ba8,hl:#f9e2af
  --color=fg:#cdd6f4,header:#89b4fa,info:#a6e3a1,pointer:#f38ba8
  --color=marker:#f38ba8,fg+:#cdd6f4,prompt:#89b4fa,hl+:#f9e2af
"

SELECTOR="fzf" # or "fzy"

WAYBAR_FLAG="/tmp/.waybar_toggle_flag"
WAYBAR_CONF_DIR=~/.config/waybar
WAYBAR_LAUNCH="$WAYBAR_CONF_DIR/launch.sh"
WAYBAR_LAUNCH_DISABLED="$WAYBAR_CONF_DIR/launch-disabled.sh"

DOCK_FLAG="/tmp/.dock_toggle_flag"
DOCK_CONF_DIR=~/.config/nwg-dock-hyprland
DOCK_LAUNCH="$DOCK_CONF_DIR/launch.sh"
DOCK_LAUNCH_DISABLED="$DOCK_CONF_DIR/launch-disabled.sh"

HYPRCONF_DIR=~/.config/hypr/conf
banner() {
  clear
  echo "
  ██████ ▓█████▄▄▄█████▓▄▄▄█████▓ ██▓ ███▄    █   ▄████   ██████ 
▒██    ▒ ▓█   ▀▓  ██▒ ▓▒▓  ██▒ ▓▒▓██▒ ██ ▀█   █  ██▒ ▀█▒▒██    ▒ 
░ ▓██▄   ▒███  ▒ ▓██░ ▒░▒ ▓██░ ▒░▒██▒▓██  ▀█ ██▒▒██░▄▄▄░░ ▓██▄   
  ▒   ██▒▒▓█  ▄░ ▓██▓ ░ ░ ▓██▓ ░ ░██░▓██▒  ▐▌██▒░▓█  ██▓  ▒   ██▒
▒██████▒▒░▒████▒ ▒██▒ ░   ▒██▒ ░ ░██░▒██░   ▓██░░▒▓███▀▒▒██████▒▒
▒ ▒▓▒ ▒ ░░░ ▒░ ░ ▒ ░░     ▒ ░░   ░▓  ░ ▒░   ▒ ▒  ░▒   ▒ ▒ ▒▓▒ ▒ ░
░ ░▒  ░ ░ ░ ░  ░   ░        ░     ▒ ░░ ░░   ░ ▒░  ░   ░ ░ ░▒  ░ ░
░  ░  ░     ░    ░        ░       ▒ ░   ░   ░ ░ ░ ░   ░ ░  ░  ░  
      ░     ░  ░                  ░           ░       ░       ░ 
  " | lolcat
}

main_menu() {
    banner
    while true; do
        choice=$(echo -e "🧩 Waybar Settings\n🛳️ Dock Settings\n🖥️ System Settings\n🚪 Exit" | $SELECTOR)
        case "$choice" in
            "🧩 Waybar Settings") waybar_menu ;;
            "🛳️ Dock Settings") dock_menu ;;
            "🖥️ System Settings") system_settings_menu ;;
            "🚪 Exit") exit ;;
        esac
    done
}

waybar_menu() {
    while true; do
        choice=$(echo -e "🎨 Change Theme\n🕹️ Toggle Waybar\n<< Back to Main Menu" | $SELECTOR)
        case "$choice" in
            "🎨 Change Theme")
                bash "$WAYBAR_CONF_DIR/switcher.sh" >/dev/null 2>&1
                ;;
            "🕹️ Toggle Waybar")
                if [[ -f "$WAYBAR_FLAG" ]]; then
                    if [[ -f "$WAYBAR_LAUNCH_DISABLED" ]]; then
                        mv "$WAYBAR_LAUNCH_DISABLED" "$WAYBAR_LAUNCH"
                    fi
                    bash "$WAYBAR_LAUNCH" >/dev/null 2>&1 &
                    rm "$WAYBAR_FLAG"
                else
                    killall waybar >/dev/null 2>&1
                    if [[ -f "$WAYBAR_LAUNCH" ]]; then
                        mv "$WAYBAR_LAUNCH" "$WAYBAR_LAUNCH_DISABLED"
                    fi
                    touch "$WAYBAR_FLAG"
                fi
                ;;
            "<< Back to Main Menu")
                return
                ;;
        esac
    done
}

toggle_autohide() {
    local file=""
    if [[ -f "$DOCK_LAUNCH" ]]; then
        file="$DOCK_LAUNCH"
    elif [[ -f "$DOCK_LAUNCH_DISABLED" ]]; then
        file="$DOCK_LAUNCH_DISABLED"
    else
        echo "No launch script found for Dock." >/dev/null 2>&1
        return
    fi

    local original_line="nwg-dock-hyprland -i 28 -x -c ~/.config/rofi/launcher-theme.sh"
    local autohide_line="nwg-dock-hyprland -i 28 -x -d -c ~/.config/rofi/launcher-theme.sh"

    if grep -Fxq "$autohide_line" "$file"; then
        sed -i "s|$autohide_line|$original_line|" "$file"
    elif grep -Fxq "$original_line" "$file"; then
        sed -i "s|$original_line|$autohide_line|" "$file"
    else
        echo "No matching nwg-dock-hyprland line found in $file." >/dev/null 2>&1
    fi

    killall nwg-dock-hyprland >/dev/null 2>&1
    if [[ -f "$DOCK_LAUNCH" ]]; then
        bash "$DOCK_LAUNCH" >/dev/null 2>&1 &
    fi
}

dock_menu() {
    while true; do
        choice=$(echo -e "🔲 Toggle Dock\n📌 Toggle Autohide\n<< Back to Main Menu" | $SELECTOR)
        case "$choice" in
            "🔲 Toggle Dock")
                if [[ -f "$DOCK_FLAG" ]]; then
                    if [[ -f "$DOCK_LAUNCH_DISABLED" ]]; then
                        mv "$DOCK_LAUNCH_DISABLED" "$DOCK_LAUNCH"
                    fi
                    bash "$DOCK_LAUNCH" >/dev/null 2>&1 &
                    rm "$DOCK_FLAG"
                else
                    killall nwg-dock-hyprland >/dev/null 2>&1
                    if [[ -f "$DOCK_LAUNCH" ]]; then
                        mv "$DOCK_LAUNCH" "$DOCK_LAUNCH_DISABLED"
                    fi
                    touch "$DOCK_FLAG"
                fi
                ;;
            "📌 Toggle Autohide")
                toggle_autohide
                ;;
            "<< Back to Main Menu")
                return
                ;;
        esac
    done
}

system_settings_menu() {
    while true; do
        choice=$(echo -e "📝 Customize Hyprconf\n<< Back to Main Menu" | $SELECTOR)
        case "$choice" in
            "📝 Customize Hyprconf") customize_hyprconf_menu ;;
            "<< Back to Main Menu")
                return

        esac
    done
}

customize_hyprconf_menu() {
    local folders=()
    while IFS= read -r -d $'\0' dir; do
        foldername="$(basename "$dir")"
        folders+=("📁 $foldername")
    done < <(find "$HYPRCONF_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

    folders+=("<< Back")
    local choice=$(printf "%s\n" "${folders[@]}" | $SELECTOR)
    if [[ "$choice" == "<< Back" ]] || [[ -z "$choice" ]]; then
        return
    fi

    foldername="${choice#* }"
    customize_hyprconf_folder_menu "$foldername"
}

customize_hyprconf_folder_menu() {
    local folder="$1"
    local folder_path="$HYPRCONF_DIR/$folder"
    local files=()
    while IFS= read -r -d $'\0' file; do
        filename="$(basename "$file")"
        files+=("📄 $filename")
    done < <(find "$folder_path" -mindepth 1 -maxdepth 1 -type f -name "*.conf" -print0)

    files+=("<< Back")
    local choice=$(printf "%s\n" "${files[@]}" | $SELECTOR)
    if [[ "$choice" == "<< Back" ]] || [[ -z "$choice" ]]; then
        return
    fi

    filename="${choice#* }"
    customize_hyprconf_file_menu "$folder" "$filename"
}

customize_hyprconf_file_menu() {
    local folder="$1"
    local filename="$2"
    while true; do
        if [[ "$filename" == custom-additional-* || "$filename" == custom-* ]]; then
            # For custom- and custom-additional- files: Execute, Edit, Delete, Back
            local options="⚡ Execute\n✏️ Edit\n🗑️ Delete\n<< Back"
        else
            # For default.conf or any file WITHOUT custom prefix: Execute, Edit, Back
            local options="⚡ Execute\n✏️ Edit\n<< Back"
        fi
        local choice=$(echo -e "$options" | $SELECTOR)
        case "$choice" in
            "⚡ Execute")
                execute_hyprconf_file "$folder" "$filename"
                ;;
            "✏️ Edit")
                if [[ "$filename" == custom-additional-* || "$filename" == custom-* ]]; then
                    select_editor_and_open "$HYPRCONF_DIR/$folder/$filename"
                    customize_hyprconf_folder_menu "$folder"
                else
                    edit_hyprconf_file_menu "$folder" "$filename"
                fi
                ;;
            "🗑️ Delete")
                delete_hyprconf_file "$folder" "$filename"
                customize_hyprconf_folder_menu "$folder"
                return
                ;;
            "<< Back"|"") return ;;
        esac
    done
}

edit_hyprconf_file_menu() {
    local folder="$1"
    local filename="$2"
    local folder_path="$HYPRCONF_DIR/$folder"

    local edit_options="📋 Copy & Create\n🆕 Additional\n<< Back"
    local edit_choice=$(echo -e "$edit_options" | $SELECTOR)
    case "$edit_choice" in
        "📋 Copy & Create")
            local default_custom="custom-${filename}"
            read -p "Enter new custom file name (default: $default_custom): " custom_name
            [[ -z "$custom_name" ]] && custom_name="$default_custom"
            [[ "$custom_name" != *.conf ]] && custom_name="${custom_name}.conf"
            [[ "$custom_name" != custom-* ]] && custom_name="custom-${custom_name}"
            local custom_file="$folder_path/$custom_name"
            cp "$folder_path/$filename" "$custom_file"
            select_editor_and_open "$custom_file"
            ;;
        "🆕 Additional")
            local default_custom="custom-additional-${filename}"
            read -p "Enter new additional file name (default: $default_custom): " custom_name
            [[ -z "$custom_name" ]] && custom_name="$default_custom"
            [[ "$custom_name" != *.conf ]] && custom_name="${custom_name}.conf"
            [[ "$custom_name" != custom-additional-* ]] && custom_name="custom-additional-${custom_name}"
            local custom_file="$folder_path/$custom_name"
            touch "$custom_file"
            select_editor_and_open "$custom_file"
            ;;
        "<< Back"|"") return ;;
    esac
    customize_hyprconf_folder_menu "$folder"
}

execute_hyprconf_file() {
    local folder="$1"
    local filename="$2"
    local conf_file="$HYPRCONF_DIR/${folder%?}.conf"
    local relpath="$folder/$filename"
    local source_line="source = ~/.config/hypr/conf/$relpath"

    if [[ "$filename" == custom-additional-* ]]; then
        # Append new line ONLY if not present
        if ! grep -Fxq "$source_line" "$conf_file"; then
            echo "$source_line" >> "$conf_file"
        fi
        notify-send "Hyprconf" "Added additional source $filename"
    else
        # Replace the first non-additional source line for this folder (preserve others!)
        awk -v folder="$folder" -v newsource="$source_line" '
        BEGIN { done=0 }
        {
          if (!done && $0 ~ "^source = ~/.config/hypr/conf/"folder"/" && $0 !~ "^source = ~/.config/hypr/conf/"folder"/custom-additional-") {
            print newsource
            done=1
          } else {
            print
          }
        }
        END {
          if (!done) print newsource
        }
        ' "$conf_file" > "${conf_file}.tmp" && mv "${conf_file}.tmp" "$conf_file"
        notify-send "Hyprconf" "Set $conf_file to source $filename"
    fi
}

delete_hyprconf_file() {
    local folder="$1"
    local filename="$2"
    local folder_path="$HYPRCONF_DIR/$folder"
    local conf_file="$HYPRCONF_DIR/${folder%?}.conf"
    local relpath="$folder/$filename"
    local source_line="source = ~/.config/hypr/conf/$relpath"
    local default_line="source = ~/.config/hypr/conf/$folder/default.conf"

    if [[ "$filename" == custom-additional-* ]]; then
        # Remove the line referencing this additional file
        awk -v rmline="$source_line" '{if ($0 != rmline) print}' "$conf_file" > "${conf_file}.tmp" && mv "${conf_file}.tmp" "$conf_file"
        rm -f "$folder_path/$filename"
        notify-send "Hyprconf" "Deleted $filename and removed its line"
    elif [[ "$filename" == custom-* ]]; then
        # Replace the first non-additional custom line with default
        awk -v folder="$folder" -v rmline="$source_line" -v defline="$default_line" '
        BEGIN { done=0 }
        {
          if (!done && $0 == rmline) {
            print defline
            done=1
          } else {
            print
          }
        }
        ' "$conf_file" > "${conf_file}.tmp" && mv "${conf_file}.tmp" "$conf_file"
        rm -f "$folder_path/$filename"
        notify-send "Hyprconf" "Deleted $filename and reset to default.conf"
    fi
}

select_editor_and_open() {
    local file="$1"
    local editor_choice=$(echo -e "nvim\nnano\n<< Back" | $SELECTOR)
    case "$editor_choice" in
        "nvim")
            nvim "$file"
            ;;
        "nano")
            nano "$file"
            ;;
        "<< Back"|"") return ;;
    esac
}

main_menu
