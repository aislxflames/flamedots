#!/bin/bash

config_file="$HOME/.config/hypr/conf/keybinds/default.conf"
mainModSymbol="SUPER"
legend="SUPER = WINDOWS KEY"

# Icon picker
get_icon() {
    case "$1" in
        *RaiseVolume*|*volume.sh\ up*) echo "🔊" ;;
        *LowerVolume*|*volume.sh\ down*) echo "🔉" ;;
        *Mute*|*volume.sh\ mute*) echo "🔇" ;;
        *killactive*) echo "" ;;
        *exit*) echo "襤" ;;
        *pseudo*|*togglesplit*) echo "" ;;
        *togglefloating*) echo "" ;;
        *terminal*|*foot*|*alacritty*|*yazi*) echo "" ;;
        *fileManager*|*thunar*|*nautilus*) echo "" ;;
        *launcher*|*rofi*|*wofi*) echo "" ;;
        *powermenu*) echo "⏻" ;;
        *switcher*) echo "" ;;
        *brightness*) echo "☀️" ;;
        *playerctl*) echo "🎵" ;;
        *cliphist*) echo "📋" ;;
        *emoji*) echo "😄" ;;
        *) echo "󰋼" ;;
    esac
}

# Extract and pair keybinds with comments
parse_keybinds() {
    awk -v mainMod="$mainModSymbol" '
    BEGIN {
        bindCount = 0;
    }

    # Capture comment line before keybind
    /^\s*#/ {
        comment = $0;
        sub(/^#\s*/, "", comment);
        next;
    }

    # Parse keybind lines
    /^[ \t]*(bind|bindel|bindm|bindl)\s*=/ {
        line = $0;
        sub(/^[ \t]*(bind[a-z]*)\s*=\s*/, "", line);
        split(line, parts, ",");
        mod = parts[1]; key = parts[2]; action = parts[3]; param = parts[4];

        gsub(/\$mainMod/, mainMod, mod);
        gsub(/^[ \t]+|[ \t]+$/, "", mod);
        gsub(/^[ \t]+|[ \t]+$/, "", key);
        gsub(/^[ \t]+|[ \t]+$/, "", action);
        gsub(/^[ \t]+|[ \t]+$/, "", param);

        combo = (mod != "" ? mod " + " key : key);
        cmd = (action == "exec" ? param : (param != "" ? action " " param : action));

        icons[bindCount] = cmd;
        combos[bindCount] = combo;
        commands[bindCount] = cmd;
        comments[bindCount] = comment;
        comment = ""; # Reset comment
        bindCount++;
    }

    END {
        for (i = 0; i < bindCount; i++) {
            icon = "󰋼";
            cmd = icons[i];
            if (cmd ~ /RaiseVolume|volume.sh up/) icon = "🔊";
            else if (cmd ~ /LowerVolume|volume.sh down/) icon = "🔉";
            else if (cmd ~ /Mute|volume.sh mute/) icon = "🔇";
            else if (cmd ~ /killactive/) icon = "";
            else if (cmd ~ /exit/) icon = "襤";
            else if (cmd ~ /pseudo|togglesplit/) icon = "";
            else if (cmd ~ /togglefloating/) icon = "";
            else if (cmd ~ /terminal|foot|alacritty|yazi/) icon = "";
            else if (cmd ~ /fileManager|thunar|nautilus/) icon = "";
            else if (cmd ~ /launcher|rofi|wofi/) icon = "";
            else if (cmd ~ /powermenu/) icon = "⏻";
            else if (cmd ~ /switcher/) icon = "";
            else if (cmd ~ /brightness/) icon = "☀️";
            else if (cmd ~ /playerctl/) icon = "🎵";
            else if (cmd ~ /cliphist/) icon = "📋";
            else if (cmd ~ /emoji/) icon = "😄";

            printf "%s  %-25s → %-50s %s\n", icon, combos[i], commands[i], comments[i];
        }
    }
    ' "$config_file"
}

# Generate final output
keybinds=$(parse_keybinds)
output="$legend\n\n$keybinds"
echo -e "$output" | rofi -dmenu -i -markup -eh 2 -p "󰌌 Keybinds"

