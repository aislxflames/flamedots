#!/bin/bash
# Web App remover script

echo -e "\033[1;31m╔══════════════════════════════════════╗\033[0m"
echo -e "\033[1;31m║         󰖟 WEB APP REMOVER          ║\033[0m"
echo -e "\033[1;31m╚══════════════════════════════════════╝\033[0m"
echo

apps_dir="$HOME/.local/share/applications"
icons_dir="$HOME/.local/share/applications/icons"

if [ ! -d "$apps_dir" ]; then
    echo "No applications directory found!"
    read -p "Press Enter to continue..."
    exit 1
fi

# Get all .desktop files
desktop_files=""
for file in "$apps_dir"/*.desktop; do
    if [ -f "$file" ]; then
        app_name=$(basename "$file" .desktop)
        desktop_files="$desktop_files$app_name\n"
    fi
done

desktop_files=$(echo -e "$desktop_files" | grep -v "^$" | sort)

if [ -z "$desktop_files" ]; then
    echo "No desktop applications found!"
    read -p "Press Enter to continue..."
    exit 1
fi

selected_app=$(echo -e "$desktop_files" | \
    fzf --preview 'echo -e "\033[1;32m󰖟 App Info:\033[0m"; cat ~/.local/share/applications/{}.desktop 2>/dev/null || echo "No info available"' \
        --preview-window=up:60%:wrap --height=90% --border=rounded \
        --header='󰍉 Select app to remove • Enter to delete • Esc to cancel' \
        --color='fg:#f8f8f2,bg:#282a36,hl:#ff5555,fg+:#f8f8f2,bg+:#44475a,hl+:#ff5555,info:#ffb86c,prompt:#ff5555,pointer:#ff79c6,marker:#ff79c6,spinner:#ffb86c,header:#6272a4' \
        --prompt='󰆴 Remove: ')

if [ -n "$selected_app" ]; then
    desktop_file="$apps_dir/$selected_app.desktop"
    icon_file="$icons_dir/$selected_app.png"
    
    echo -e "\033[1;33m󰚰 Removing web app: $selected_app\033[0m"
    
    # Remove desktop file
    if [ -f "$desktop_file" ]; then
        rm "$desktop_file"
        echo -e "\033[1;32m✓ Removed desktop file\033[0m"
    fi
    
    # Remove icon file
    if [ -f "$icon_file" ]; then
        rm "$icon_file"
        echo -e "\033[1;32m✓ Removed icon file\033[0m"
    fi
    
    echo -e "\033[1;32m󰄬 Web app removed!\033[0m"
    read -p "Press Enter to continue..."
fi
