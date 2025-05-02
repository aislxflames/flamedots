#!/bin/bash

config_file="$HOME/.config/hypr/conf/keybinds.conf"
mainModSymbol="SUPER"
legend="SUPER = WINDOWS KEY"

# Icon picker based on action/key
get_icon() {
    case "$1" in
        *RaiseVolume*) echo "🔊" ;;
        *LowerVolume*) echo "🔉" ;;
        *Mute*) echo "🔇" ;;
        *killactive*) echo "" ;;          # Font Awesome 'times-circle'
        *exit*) echo "襤" ;;               # MDI 'exit-to-app'
        *pseudo*|*togglesplit*) echo "" ;; # Material 'layout'
        *togglefloating*) echo "" ;;      # Font Awesome 'window-restore'
        *terminal*|*foot*|*alacritty*) echo "" ;; # Devicon 'terminal'
        *fileManager*|*thunar*|*nautilus*) echo "" ;; # Font Awesome 'folder'
        *launcher*|*wofi*|*rofi*) echo "" ;; # Font Awesome 'rocket'
        *powermenu*) echo "⏻" ;;           # Unicode power icon
        *switcher*) echo "" ;;            # Font Awesome 'desktop'
        *) echo "󰋼" ;;                    # Default: Material 'dots-horizontal'
    esac
}

# Parse and format keybinds
keybinds=$(grep -E '^bind' "$config_file" | while read -r line; do
    line="${line//\$mainMod/$mainModSymbol}"
    line=$(echo "$line" | sed -E 's/^bind[a-z]*[[:space:]]*=[[:space:]]*//')

    IFS=',' read -r mod key action rest <<< "$line"

    mod=$(echo "$mod" | xargs | sed 's/+ */ + /g')
    key=$(echo "$key" | xargs)
    action=$(echo "$action" | xargs)
    rest=$(echo "$rest" | xargs)
    cmd=$(echo "$action $rest" | sed 's/^exec //')

    icon=$(get_icon "$cmd")

    # Only add "+" if there's a modifier
    if [[ -n "$mod" ]]; then
        combo="$mod + $key"
    else
        combo="$key"
    fi

    printf "%s  %-30s → %s\n" "$icon" "$combo" "$cmd"
done)

# Show in rofi
output="$legend\n\n$keybinds"
echo -e "$output" | rofi -dmenu -i -markup -eh 2 -p "󰌌 Keybinds"

