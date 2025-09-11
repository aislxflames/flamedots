#!/bin/bash

export FZF_DEFAULT_OPTS="
  --reverse
  --height=60%
  --layout=reverse
  --border=rounded
  --margin=2,4
  --padding=1
  --color=spinner:#f38ba8,hl:#f9e2af
  --color=fg:#cdd6f4,header:#89b4fa,info:#a6e3a1,pointer:#f38ba8
  --color=marker:#f38ba8,fg+:#cdd6f4,prompt:#89b4fa,hl+:#f9e2af
  --color=border:#585b70,gutter:#1e1e2e
  --prompt='⚙️  '
  --pointer='▶'
  --marker='✓'
"

SELECTOR="fzf"

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
    echo -e "\033[1;36m"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    ⚙️  FLAMES SETTINGS                        ║"
    echo "╠══════════════════════════════════════════════════════════════╣"
    echo "║                 Configure Your Desktop                       ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "\033[0m\n"
}

main_menu() {
    banner
    while true; do
        echo -e "\033[1;35m┌─ Main Categories ─────────────────────────────────────────┐\033[0m"
        choice=$(echo -e "🎨 Appearance & Themes\n🖥️ Interface & Layout\n⚙️ System Configuration\n🔧 Advanced Settings\n❌ Exit" | $SELECTOR --header="Select a category:")
        case "$choice" in
            "🎨 Appearance & Themes") appearance_menu ;;
            "🖥️ Interface & Layout") interface_menu ;;
            "⚙️ System Configuration") system_menu ;;
            "🔧 Advanced Settings") advanced_menu ;;
            "❌ Exit") clear; exit ;;
        esac
    done
}

appearance_menu() {
    while true; do
        banner
        echo -e "\033[1;33m┌─ Appearance & Themes ─────────────────────────────────────┐\033[0m"
        choice=$(echo -e "🖼️ Wallpaper Selector\n🎨 Waybar Themes\n🌈 Theme Selector\n📥 Wallpaper & Themes\n⬅️ Back" | $SELECTOR --header="Customize your desktop appearance:")
        case "$choice" in
            "🖼️ Wallpaper Selector") wallpaper_selector ;;
            "🎨 Waybar Themes") waybar_themes ;;
            "🌈 Theme Selector") theme_selector ;;
            "📥 Wallpaper & Themes") ~/.config/flames/scripts/wallpaper-downloader.sh ;;
            "⬅️ Back") return ;;
        esac
    done
}

interface_menu() {
    while true; do
        banner
        echo -e "\033[1;32m┌─ Interface & Layout ──────────────────────────────────────┐\033[0m"
        choice=$(echo -e "📊 Waybar Controls\n🚢 Dock Management\n🖱️ Input Settings\n⬅️ Back" | $SELECTOR --header="Configure interface elements:")
        case "$choice" in
            "📊 Waybar Controls") waybar_menu ;;
            "🚢 Dock Management") dock_menu ;;
            "🖱️ Input Settings") input_settings ;;
            "⬅️ Back") return ;;
        esac
    done
}

system_menu() {
    while true; do
        banner
        echo -e "\033[1;31m┌─ System Configuration ────────────────────────────────────┐\033[0m"
        choice=$(echo -e "🔧 Hyprland Config\n🔊 Audio Settings\n🌐 Network Settings\n⬅️ Back" | $SELECTOR --header="System configuration options:")
        case "$choice" in
            "🔧 Hyprland Config") hyprland_config_menu ;;
            "🔊 Audio Settings") audio_settings ;;
            "🌐 Network Settings") network_settings ;;
            "⬅️ Back") return ;;
        esac
    done
}

advanced_menu() {
    while true; do
        banner
        echo -e "\033[1;34m┌─ Advanced Settings ───────────────────────────────────────┐\033[0m"
        choice=$(echo -e "📝 Edit Configs\n🔄 Reload System\n🛠️ Debug Tools\n⬅️ Back" | $SELECTOR --header="Advanced configuration:")
        case "$choice" in
            "📝 Edit Configs") edit_configs_menu ;;
            "🔄 Reload System") reload_system ;;
            "🛠️ Debug Tools") debug_tools ;;
            "⬅️ Back") return ;;
        esac
    done
}

waybar_themes() {
    bash "$WAYBAR_CONF_DIR/switcher.sh" >/dev/null 2>&1
}

waybar_menu() {
    while true; do
        banner
        local status="$([ -f "$WAYBAR_FLAG" ] && echo "🔴 Disabled" || echo "🟢 Enabled")"
        choice=$(echo -e "🔄 Toggle Waybar ($status)\n🎨 Change Theme\n📊 Waybar Settings\n⬅️ Back" | $SELECTOR --header="Waybar controls:")
        case "$choice" in
            "🔄 Toggle Waybar"*)
                if [[ -f "$WAYBAR_FLAG" ]]; then
                    [[ -f "$WAYBAR_LAUNCH_DISABLED" ]] && mv "$WAYBAR_LAUNCH_DISABLED" "$WAYBAR_LAUNCH"
                    nohup bash "$WAYBAR_LAUNCH" >/dev/null 2>&1 & disown
                    rm "$WAYBAR_FLAG"
                    notify-send "Waybar" "Enabled" -i "dialog-information"
                else
                    killall waybar >/dev/null 2>&1
                    [[ -f "$WAYBAR_LAUNCH" ]] && mv "$WAYBAR_LAUNCH" "$WAYBAR_LAUNCH_DISABLED"
                    touch "$WAYBAR_FLAG"
                    notify-send "Waybar" "Disabled" -i "dialog-warning"
                fi
                ;;
            "🎨 Change Theme") waybar_themes ;;
            "📊 Waybar Settings") waybar_advanced_settings ;;
            "⬅️ Back") return ;;
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

    local original_line="nwg-dock-hyprland -i 28 -x -c ~/.config/rofi/launcher-theme.sh &"
    local autohide_line="nwg-dock-hyprland -i 28 -x -d -c ~/.config/rofi/launcher-theme.sh &"

    if grep -Fxq "$autohide_line" "$file"; then
        sed -i "s|$autohide_line|$original_line|" "$file"
    elif grep -Fxq "$original_line" "$file"; then
        sed -i "s|$original_line|$autohide_line|" "$file"
    else
        echo "No matching nwg-dock-hyprland line found in $file." >/dev/null 2>&1
    fi

    killall nwg-dock-hyprland >/dev/null 2>&1
    if [[ -f "$DOCK_LAUNCH" ]]; then
        nohup bash "$DOCK_LAUNCH" >/dev/null 2>&1 & disown
    fi
}

dock_menu() {
    while true; do
        banner
        local dock_status="$([ -f "$DOCK_FLAG" ] && echo "🔴 Disabled" || echo "🟢 Enabled")"
        choice=$(echo -e "🔄 Toggle Dock ($dock_status)\n📌 Toggle Autohide\n🎨 Dock Themes\n⬅️ Back" | $SELECTOR --header="Dock management:")
        case "$choice" in
            "🔄 Toggle Dock"*)
                if [[ -f "$DOCK_FLAG" ]]; then
                    [[ -f "$DOCK_LAUNCH_DISABLED" ]] && mv "$DOCK_LAUNCH_DISABLED" "$DOCK_LAUNCH"
                    nohup bash "$DOCK_LAUNCH" >/dev/null 2>&1 & disown
                    rm "$DOCK_FLAG"
                    notify-send "Dock" "Enabled" -i "dialog-information"
                else
                    killall nwg-dock-hyprland >/dev/null 2>&1
                    [[ -f "$DOCK_LAUNCH" ]] && mv "$DOCK_LAUNCH" "$DOCK_LAUNCH_DISABLED"
                    touch "$DOCK_FLAG"
                    notify-send "Dock" "Disabled" -i "dialog-warning"
                fi
                ;;
            "📌 Toggle Autohide") toggle_autohide ;;
            "🎨 Dock Themes") dock_themes ;;
            "⬅️ Back") return ;;
        esac
    done
}

input_settings() {
    choice=$(echo -e "🖱️ Mouse Settings\n⌨️ Keyboard Settings\n🎮 Gamepad Settings\n⬅️ Back" | $SELECTOR --header="Input device settings:")
    case "$choice" in
        "🖱️ Mouse Settings") mouse_settings ;;
        "⌨️ Keyboard Settings") keyboard_settings ;;
        "🎮 Gamepad Settings") gamepad_settings ;;
        "⬅️ Back") return ;;
    esac
}

hyprland_config_menu() {
    choice=$(echo -e "📝 Edit Hyprland Config\n🔧 Workspace Settings\n🪟 Window Rules\n⬅️ Back" | $SELECTOR --header="Hyprland configuration:")
    case "$choice" in
        "📝 Edit Hyprland Config") customize_hyprconf_menu ;;
        "🔧 Workspace Settings") workspace_settings ;;
        "🪟 Window Rules") window_rules ;;
        "⬅️ Back") return ;;
    esac
}

audio_settings() {
    choice=$(echo -e "🔊 Volume Control\n🎵 Audio Devices\n🎤 Microphone\n⬅️ Back" | $SELECTOR --header="Audio configuration:")
    case "$choice" in
        "🔊 Volume Control") ~/.config/flames/scripts/volume.sh ;;
        "🎵 Audio Devices") pavucontrol ;;
        "🎤 Microphone") mic_settings ;;
        "⬅️ Back") return ;;
    esac
}

network_settings() {
    choice=$(echo -e "📶 WiFi Manager\n🌐 Network Config\n🔒 VPN Settings\n⬅️ Back" | $SELECTOR --header="Network configuration:")
    case "$choice" in
        "📶 WiFi Manager") ~/.config/flames/scripts/wifi.sh ;;
        "🌐 Network Config") nm-connection-editor ;;
        "🔒 VPN Settings") vpn_settings ;;
        "⬅️ Back") return ;;
    esac
}

edit_configs_menu() {
    choice=$(echo -e "📝 Hypr Configs\n⚙️ Waybar Config\n🚢 Dock Config\n🎨 Theme Files\n⬅️ Back" | $SELECTOR --header="Edit configuration files:")
    case "$choice" in
        "📝 Hypr Configs") customize_hyprconf_menu ;;
        "⚙️ Waybar Config") edit_waybar_config ;;
        "🚢 Dock Config") edit_dock_config ;;
        "🎨 Theme Files") edit_theme_files ;;
        "⬅️ Back") return ;;
    esac
}

reload_system() {
    choice=$(echo -e "🔄 Reload Hyprland\n📊 Restart Waybar\n🚢 Restart Dock\n🎨 Reload Themes\n⬅️ Back" | $SELECTOR --header="System reload options:")
    case "$choice" in
        "🔄 Reload Hyprland") hyprctl reload && notify-send "System" "Hyprland reloaded" ;;
        "📊 Restart Waybar") killall waybar >/dev/null 2>&1; nohup bash "$WAYBAR_LAUNCH" >/dev/null 2>&1 & disown; notify-send "System" "Waybar restarted" ;;
        "🚢 Restart Dock") killall nwg-dock-hyprland >/dev/null 2>&1; nohup bash "$DOCK_LAUNCH" >/dev/null 2>&1 & disown; notify-send "System" "Dock restarted" ;;
        "🎨 Reload Themes") ~/.config/flames/scripts/sysreload.sh ;;
        "⬅️ Back") return ;;
    esac
}

debug_tools() {
    choice=$(echo -e "🔍 System Info\n📊 Process Monitor\n📝 Log Viewer\n⬅️ Back" | $SELECTOR --header="Debug and monitoring tools:")
    case "$choice" in
        "🔍 System Info") system_info ;;
        "📊 Process Monitor") htop ;;
        "📝 Log Viewer") journalctl -f ;;
        "⬅️ Back") return ;;
    esac
}

# Placeholder functions for new features
waybar_advanced_settings() { notify-send "Settings" "Waybar advanced settings - Coming soon!"; }
dock_themes() { notify-send "Settings" "Dock themes - Coming soon!"; }
mouse_settings() { notify-send "Settings" "Mouse settings - Coming soon!"; }
keyboard_settings() { notify-send "Settings" "Keyboard settings - Coming soon!"; }
gamepad_settings() { notify-send "Settings" "Gamepad settings - Coming soon!"; }
workspace_settings() { notify-send "Settings" "Workspace settings - Coming soon!"; }
window_rules() { notify-send "Settings" "Window rules - Coming soon!"; }
mic_settings() { notify-send "Settings" "Microphone settings - Coming soon!"; }
vpn_settings() { notify-send "Settings" "VPN settings - Coming soon!"; }
edit_waybar_config() { select_editor_and_open "$WAYBAR_CONF_DIR/config"; }
edit_dock_config() { select_editor_and_open "$DOCK_CONF_DIR/style.css"; }
edit_theme_files() { notify-send "Settings" "Theme file editor - Coming soon!"; }
system_info() { neofetch; read -p "Press Enter to continue..."; }
wallpaper_selector() { ~/.local/bin/walset; }
theme_selector() { ~/.config/flames/scripts/theme-switcher.sh; }

customize_hyprconf_menu() {
    local folders=()
    while IFS= read -r -d $'\0' dir; do
        foldername="$(basename "$dir")"
        folders+=("📁 $foldername")
    done < <(find "$HYPRCONF_DIR" -mindepth 1 -maxdepth 1 -type d -print0)

    folders+=("⬅️  Back")
    local choice=$(printf "%s\n" "${folders[@]}" | $SELECTOR --header="Select configuration folder:")
    if [[ "$choice" == "⬅️  Back" ]] || [[ -z "$choice" ]]; then
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

    files+=("⬅️ Back")
    local choice=$(printf "%s\n" "${files[@]}" | $SELECTOR --header="Configuration files in $folder:")
    if [[ "$choice" == "⬅️ Back" ]] || [[ -z "$choice" ]]; then
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
            local options="⚡ Execute\n✏️ Edit\n🗑️ Delete\n⬅️ Back"
        else
            local options="⚡ Execute\n✏️ Edit\n⬅️ Back"
        fi
        local choice=$(echo -e "$options" | $SELECTOR --header="Actions for $filename:")
        case "$choice" in
            "⚡ Execute") execute_hyprconf_file "$folder" "$filename" ;;
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
            "⬅️ Back"|"") return ;;
        esac
    done
}

edit_hyprconf_file_menu() {
    local folder="$1"
    local filename="$2"
    local folder_path="$HYPRCONF_DIR/$folder"

    local edit_options="📋 Copy & Create\n🆕 Additional\n⬅️ Back"
    local edit_choice=$(echo -e "$edit_options" | $SELECTOR --header="Edit options for $filename:")
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
        "⬅️ Back"|"") return ;;
    esac
    customize_hyprconf_folder_menu "$folder"
}

select_editor_and_open() {
    local file="$1"
    local editor_choice=$(echo -e "nvim\nnano\n⬅️ Back" | $SELECTOR --header="Choose editor:")
    case "$editor_choice" in
        "nvim") nvim "$file" ;;
        "nano") nano "$file" ;;
        "⬅️ Back"|"") return ;;
    esac
}

main_menu
