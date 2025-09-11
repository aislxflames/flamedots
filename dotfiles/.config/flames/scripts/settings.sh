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



waybar_menu() {
    while true; do
        banner
        local status="$([ -f "$WAYBAR_FLAG" ] && echo "🔴 Disabled" || echo "🟢 Enabled")"
        choice=$(echo -e "🔄 Toggle Waybar ($status)\n🎨 Change Theme\n📊 Waybar Settings\n⬅️ Back" | $SELECTOR --header="Waybar controls:")
        case "$choice" in
            "🔄 Toggle Waybar"*)
                if [[ -f "$WAYBAR_FLAG" ]]; then
                    # Enable waybar
                    [[ -f "$WAYBAR_LAUNCH_DISABLED" ]] && mv "$WAYBAR_LAUNCH_DISABLED" "$WAYBAR_LAUNCH"
                    if [[ -f "$WAYBAR_LAUNCH" ]]; then
                        nohup bash "$WAYBAR_LAUNCH" >/dev/null 2>&1 & disown
                        rm "$WAYBAR_FLAG" 2>/dev/null
                        notify-send "Waybar" "Enabled successfully" -i "dialog-information"
                    else
                        notify-send "Error" "Waybar launch script not found" -i "dialog-error"
                    fi
                else
                    # Disable waybar
                    killall waybar >/dev/null 2>&1
                    [[ -f "$WAYBAR_LAUNCH" ]] && mv "$WAYBAR_LAUNCH" "$WAYBAR_LAUNCH_DISABLED"
                    touch "$WAYBAR_FLAG"
                    notify-send "Waybar" "Disabled successfully" -i "dialog-warning"
                fi
                ;;
            "🎨 Change Theme") 
                if [[ -f "$WAYBAR_CONF_DIR/switcher.sh" ]]; then
                    bash "$WAYBAR_CONF_DIR/switcher.sh" >/dev/null 2>&1
                else
                    notify-send "Error" "Waybar theme switcher not found" -i "dialog-error"
                fi
                ;;
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
        echo "No launch script found for Dock." >&2
        return 1
    fi

    local original_line="nwg-dock-hyprland -i 28 -x -c ~/.config/rofi/launcher-theme.sh &"
    local autohide_line="nwg-dock-hyprland -i 28 -x -d -c ~/.config/rofi/launcher-theme.sh &"

    if grep -Fxq "$autohide_line" "$file"; then
        # Currently has autohide, remove it
        sed -i "s|$autohide_line|$original_line|" "$file"
    elif grep -Fxq "$original_line" "$file"; then
        # Currently no autohide, add it
        sed -i "s|$original_line|$autohide_line|" "$file"
    else
        echo "No matching nwg-dock-hyprland line found in $file." >&2
        return 1
    fi

    # Restart dock if it's currently running
    killall nwg-dock-hyprland >/dev/null 2>&1
    if [[ -f "$DOCK_LAUNCH" ]]; then
        nohup bash "$DOCK_LAUNCH" >/dev/null 2>&1 & disown
    fi
    
    return 0
}

dock_menu() {
    while true; do
        banner
        local dock_status="$([ -f "$DOCK_FLAG" ] && echo "🔴 Disabled" || echo "🟢 Enabled")"
        choice=$(echo -e "🔄 Toggle Dock ($dock_status)\n📌 Toggle Autohide\n🎨 Dock Themes\n⬅️ Back" | $SELECTOR --header="Dock management:")
        case "$choice" in
            "🔄 Toggle Dock"*)
                if [[ -f "$DOCK_FLAG" ]]; then
                    # Enable dock
                    [[ -f "$DOCK_LAUNCH_DISABLED" ]] && mv "$DOCK_LAUNCH_DISABLED" "$DOCK_LAUNCH"
                    if [[ -f "$DOCK_LAUNCH" ]]; then
                        nohup bash "$DOCK_LAUNCH" >/dev/null 2>&1 & disown
                        rm "$DOCK_FLAG" 2>/dev/null
                        notify-send "Dock" "Enabled successfully" -i "dialog-information"
                    else
                        notify-send "Error" "Dock launch script not found" -i "dialog-error"
                    fi
                else
                    # Disable dock
                    killall nwg-dock-hyprland >/dev/null 2>&1
                    [[ -f "$DOCK_LAUNCH" ]] && mv "$DOCK_LAUNCH" "$DOCK_LAUNCH_DISABLED"
                    touch "$DOCK_FLAG"
                    notify-send "Dock" "Disabled successfully" -i "dialog-warning"
                fi
                ;;
            "📌 Toggle Autohide") 
                if toggle_autohide; then
                    notify-send "Dock" "Autohide toggled successfully" -i "dialog-information"
                else
                    notify-send "Error" "Failed to toggle autohide" -i "dialog-error"
                fi
                ;;
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
    local folders=()
    
    # Check if conf directory exists
    if [[ ! -d "$HYPRCONF_DIR" ]]; then
        notify-send "Error" "Hyprland config directory not found: $HYPRCONF_DIR" -i "dialog-error"
        return 1
    fi
    
    while IFS= read -r -d $'\0' dir; do
        foldername="$(basename "$dir")"
        folders+=("📁 $foldername")
    done < <(find "$HYPRCONF_DIR" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)

    folders+=("❓ Help - What are these configs?")
    folders+=("⬅️ Back")
    
    local choice=$(printf "%s\n" "${folders[@]}" | $SELECTOR --header="Hyprland Configuration:")
    
    case "$choice" in
        "❓ Help - What are these configs?")
            show_hyprland_help
            hyprland_config_menu
            ;;
        "⬅️ Back"|"") 
            return 
            ;;
        *)
            if [[ "$choice" == "📁 "* ]]; then
                foldername="${choice#📁 }"
                customize_hyprconf_folder_menu "$foldername"
            fi
            ;;
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
    choice=$(echo -e "⚙️ Waybar Config\n🚢 Dock Config\n🎨 Theme Files\n⬅️ Back" | $SELECTOR --header="Edit configuration files:")
    case "$choice" in
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



customize_hyprconf_folder_menu() {
    local folder="$1"
    local folder_path="$HYPRCONF_DIR/$folder"
    
    if [[ ! -d "$folder_path" ]]; then
        notify-send "Error" "Configuration folder not found: $folder" -i "dialog-error"
        return 1
    fi
    
    local files=()
    while IFS= read -r -d $'\0' file; do
        filename="$(basename "$file")"
        if [[ "$filename" == custom-* ]]; then
            files+=("📝 $filename (Custom)")
        else
            files+=("📄 $filename")
        fi
    done < <(find "$folder_path" -mindepth 1 -maxdepth 1 -type f -name "*.conf" -print0 2>/dev/null)

    if [[ ${#files[@]} -eq 0 ]]; then
        notify-send "Info" "No configuration files found in $folder" -i "dialog-information"
        return
    fi

    files+=("➕ Create New Custom Config")
    files+=("❓ Help - What is $folder?")
    files+=("⬅️ Back")
    
    local choice=$(printf "%s\n" "${files[@]}" | $SELECTOR --header="Configuration files in $folder:")
    
    case "$choice" in
        "➕ Create New Custom Config")
            create_custom_config "$folder"
            customize_hyprconf_folder_menu "$folder"
            ;;
        "❓ Help - What is $folder?")
            show_folder_help "$folder"
            customize_hyprconf_folder_menu "$folder"
            ;;
        "⬅️ Back"|"")
            return
            ;;
        *)
            if [[ "$choice" == "📄 "* ]]; then
                filename="${choice#📄 }"
            elif [[ "$choice" == "📝 "* ]]; then
                filename="${choice#📝 }"
                filename="${filename% (Custom)}"
            fi
            customize_hyprconf_file_menu "$folder" "$filename"
            ;;
    esac
}

customize_hyprconf_file_menu() {
    local folder="$1"
    local filename="$2"
    while true; do
        if [[ "$filename" == custom-additional-* || "$filename" == custom-* ]]; then
            local options="⚡ Apply Config\n✏️ Edit\n🗑️ Delete\n⬅️ Back"
        else
            local options="⚡ Apply Config\n✏️ Edit\n⬅️ Back"
        fi
        local choice=$(echo -e "$options" | $SELECTOR --header="Actions for $filename:")
        case "$choice" in
            "⚡ Apply Config") 
                apply_hyprconf_file "$folder" "$filename"
                ;;
            "✏️ Edit")
                if [[ "$filename" == custom-additional-* || "$filename" == custom-* ]]; then
                    select_editor_and_open "$HYPRCONF_DIR/$folder/$filename"
                else
                    edit_hyprconf_file_menu "$folder" "$filename"
                fi
                ;;
            "🗑️ Delete")
                delete_hyprconf_file "$folder" "$filename"
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

# Apply Hyprland configuration file
apply_hyprconf_file() {
    local folder="$1"
    local filename="$2"
    local file_path="$HYPRCONF_DIR/$folder/$filename"
    local main_config="/home/aislx/.config/hypr/hyprland.conf"
    
    if [[ ! -f "$file_path" ]]; then
        notify-send "Error" "Configuration file not found: $filename" -i "dialog-error"
        return 1
    fi
    
    # Add source line to main config if not already present
    local source_line="source = $file_path"
    if ! grep -Fxq "$source_line" "$main_config"; then
        echo "$source_line" >> "$main_config"
        notify-send "Success" "Added $filename to Hyprland config" -i "dialog-information"
    fi
    
    # Reload Hyprland to apply changes
    if hyprctl reload >/dev/null 2>&1; then
        notify-send "Success" "Applied $filename configuration" -i "dialog-information"
    else
        notify-send "Error" "Failed to reload Hyprland" -i "dialog-error"
    fi
}

# Delete custom Hyprland configuration file
delete_hyprconf_file() {
    local folder="$1"
    local filename="$2"
    local file_path="$HYPRCONF_DIR/$folder/$filename"
    
    # Only allow deletion of custom files
    if [[ "$filename" != custom-* ]]; then
        notify-send "Error" "Cannot delete system configuration files" -i "dialog-error"
        return 1
    fi
    
    local confirm=$(echo -e "Yes\nNo" | $SELECTOR --header="Delete $filename? This cannot be undone!")
    if [[ "$confirm" == "Yes" ]]; then
        if rm "$file_path" 2>/dev/null; then
            notify-send "Success" "Deleted $filename" -i "dialog-information"
        else
            notify-send "Error" "Failed to delete $filename" -i "dialog-error"
        fi
    fi
}

# Check if required commands exist
check_dependencies() {
    local missing_deps=()
    
    command -v fzf >/dev/null || missing_deps+=("fzf")
    command -v hyprctl >/dev/null || missing_deps+=("hyprland")
    command -v notify-send >/dev/null || missing_deps+=("libnotify")
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "❌ Missing dependencies: ${missing_deps[*]}"
        echo "Please install them first:"
        for dep in "${missing_deps[@]}"; do
            case "$dep" in
                "fzf") echo "  sudo pacman -S fzf" ;;
                "hyprland") echo "  sudo pacman -S hyprland" ;;
                "libnotify") echo "  sudo pacman -S libnotify" ;;
            esac
        done
        exit 1
    fi
}

# Create required directories if they don't exist
setup_directories() {
    local dirs=(
        "$WAYBAR_CONF_DIR"
        "$DOCK_CONF_DIR" 
        "$HYPRCONF_DIR"
    )
    
    for dir in "${dirs[@]}"; do
        [[ ! -d "$dir" ]] && mkdir -p "$dir"
    done
}

# Show help information about Hyprland configuration
show_hyprland_help() {
    clear
    echo -e "\033[1;36m"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                 🔧 HYPRLAND CONFIG HELP                      ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "\033[0m"
    echo -e "\033[1;33mWhat are these configuration folders?\033[0m\n"
    echo "📁 animations    - Control window animations and effects"
    echo "📁 borders       - Window border styles and colors"
    echo "📁 decorations   - Window decorations (shadows, blur, etc.)"
    echo "📁 inputs        - Mouse and keyboard settings"
    echo "📁 keybinds      - Keyboard shortcuts and hotkeys"
    echo "📁 layouts       - Window tiling layouts"
    echo "📁 monitors      - Display and monitor configuration"
    echo "📁 programs      - Program-specific settings"
    echo "📁 windowrules   - Rules for specific windows"
    echo "📁 workspaces    - Virtual desktop settings"
    echo ""
    echo -e "\033[1;32m💡 Tips for beginners:\033[0m"
    echo "• Start with 'keybinds' to customize shortcuts"
    echo "• Use 'monitors' to set up your displays"
    echo "• Try 'decorations' for visual effects"
    echo "• Always create custom configs instead of editing originals"
    echo ""
    read -p "Press Enter to continue..."
}

# Show help for specific configuration folder
show_folder_help() {
    local folder="$1"
    clear
    echo -e "\033[1;36m"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    📁 $folder HELP                           ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "\033[0m"
    
    case "$folder" in
        "keybinds")
            echo "🔧 Keybinds Configuration"
            echo "• Set up keyboard shortcuts for launching apps"
            echo "• Configure window management hotkeys"
            echo "• Example: bind = SUPER, T, exec, kitty"
            ;;
        "monitors")
            echo "🖥️ Monitor Configuration"
            echo "• Set resolution, refresh rate, and position"
            echo "• Configure multiple monitor setups"
            echo "• Example: monitor=DP-1,1920x1080@60,0x0,1"
            ;;
        "decorations")
            echo "🎨 Decorations Configuration"
            echo "• Window shadows, blur effects, and rounding"
            echo "• Transparency and visual effects"
            echo "• Example: rounding = 10"
            ;;
        "animations")
            echo "✨ Animations Configuration"
            echo "• Window open/close animations"
            echo "• Workspace switching effects"
            echo "• Animation speed and curves"
            ;;
        *)
            echo "📋 $folder Configuration"
            echo "• Contains settings specific to $folder"
            echo "• Create custom configs to override defaults"
            echo "• Use 'Apply Config' to test changes"
            ;;
    esac
    
    echo ""
    echo -e "\033[1;32m💡 Remember:\033[0m"
    echo "• Always backup before making changes"
    echo "• Test configs before applying permanently"
    echo "• Use custom configs to avoid losing changes"
    echo ""
    read -p "Press Enter to continue..."
}

# Create a new custom configuration file
create_custom_config() {
    local folder="$1"
    local folder_path="$HYPRCONF_DIR/$folder"
    
    echo "Creating new custom configuration for $folder..."
    read -p "Enter name for your custom config (without .conf): " config_name
    
    if [[ -z "$config_name" ]]; then
        notify-send "Error" "Config name cannot be empty" -i "dialog-error"
        return 1
    fi
    
    # Ensure it starts with custom- and ends with .conf
    [[ "$config_name" != custom-* ]] && config_name="custom-$config_name"
    [[ "$config_name" != *.conf ]] && config_name="$config_name.conf"
    
    local custom_file="$folder_path/$config_name"
    
    if [[ -f "$custom_file" ]]; then
        notify-send "Error" "Config file already exists: $config_name" -i "dialog-error"
        return 1
    fi
    
    # Create template based on folder type
    case "$folder" in
        "keybinds")
            cat > "$custom_file" << 'EOF'
# Custom Keybinds Configuration
# Example keybinds - modify as needed

# Launch applications
bind = SUPER, T, exec, kitty
bind = SUPER, E, exec, nautilus
bind = SUPER, B, exec, firefox

# Window management
bind = SUPER, Q, killactive
bind = SUPER, F, fullscreen
bind = SUPER, V, togglefloating
EOF
            ;;
        "monitors")
            cat > "$custom_file" << 'EOF'
# Custom Monitor Configuration
# Replace with your actual monitor names and resolutions

# Primary monitor
monitor = DP-1, 1920x1080@60, 0x0, 1

# Secondary monitor (uncomment and modify if needed)
# monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
EOF
            ;;
        *)
            cat > "$custom_file" << EOF
# Custom $folder Configuration
# Add your custom settings here

# Example setting (remove this line)
# setting = value
EOF
            ;;
    esac
    
    notify-send "Success" "Created custom config: $config_name" -i "dialog-information"
    
    # Ask if user wants to edit it now
    local edit_choice=$(echo -e "Yes\nNo" | $SELECTOR --header="Edit the new config file now?")
    if [[ "$edit_choice" == "Yes" ]]; then
        select_editor_and_open "$custom_file"
    fi
}

# Initialize the script
init_script() {
    check_dependencies
    setup_directories
    
    # Create default launch scripts if they don't exist
    if [[ ! -f "$WAYBAR_LAUNCH" && ! -f "$WAYBAR_LAUNCH_DISABLED" ]]; then
        cat > "$WAYBAR_LAUNCH" << 'EOF'
#!/bin/bash
killall waybar 2>/dev/null
waybar &
EOF
        chmod +x "$WAYBAR_LAUNCH"
    fi
    
    if [[ ! -f "$DOCK_LAUNCH" && ! -f "$DOCK_LAUNCH_DISABLED" ]]; then
        cat > "$DOCK_LAUNCH" << 'EOF'
#!/bin/bash
killall nwg-dock-hyprland 2>/dev/null
nwg-dock-hyprland -i 28 -x -c ~/.config/rofi/launcher-theme.sh &
EOF
        chmod +x "$DOCK_LAUNCH"
    fi
}

# Run initialization and start main menu
init_script
main_menu
