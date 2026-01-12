#!/bin/bash
# Flatpak Package installer with enhanced UI

echo -e "\033[1;34m╔══════════════════════════════════════╗\033[0m"
echo -e "\033[1;34m║         󰏔 FLATPAK PACKAGES         ║\033[0m"
echo -e "\033[1;34m╚══════════════════════════════════════╝\033[0m"
echo

selected_packages=$(flatpak search --columns=application,name,description 2>/dev/null | \
    fzf --multi --preview 'echo -e "\033[1;32m󰋽 Package Info:\033[0m"; flatpak info {1} 2>/dev/null || echo "No info available"' \
        --preview-window=up:60%:wrap --height=90% --border=rounded \
        --bind 'change:reload(flatpak search {q} --columns=application,name,description 2>/dev/null | tail -n +1)' \
        --header='󰍉 Type to search • Tab to select • Enter to install • Esc to cancel' \
        --color='fg:#f8f8f2,bg:#282a36,hl:#8be9fd,fg+:#f8f8f2,bg+:#44475a,hl+:#8be9fd,info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#ffb86c,header:#6272a4' \
        --prompt='󰍉 Search: ' \
        --query='')

if [ -n "$selected_packages" ]; then
    echo -e "\033[1;33m󰚰 Installing Flatpaks: $selected_packages\033[0m"
    echo "$selected_packages" | while read -r line; do
        if [ -n "$line" ]; then
            package=$(echo "$line" | awk '{print $1}')
            flatpak install -y "$package"
        fi
    done
    echo -e "\033[1;32m󰄬 Installation complete!\033[0m"
    read -p "Press Enter to continue..."
fi
