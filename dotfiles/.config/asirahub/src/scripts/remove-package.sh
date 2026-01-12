#!/bin/bash
# Package remover script

echo -e "\033[1;31m╔══════════════════════════════════════╗\033[0m"
echo -e "\033[1;31m║         󰆴 PACKAGE REMOVER          ║\033[0m"
echo -e "\033[1;31m╚══════════════════════════════════════╝\033[0m"
echo

selected_package=$(pacman -Qq | \
    fzf --preview 'echo -e "\033[1;32m󰋽 Package Info:\033[0m"; pacman -Qi {} 2>/dev/null || echo "No info available"' \
        --preview-window=up:60%:wrap --height=90% --border=rounded \
        --header='󰍉 Select package to remove • Enter to uninstall • Esc to cancel' \
        --color='fg:#f8f8f2,bg:#282a36,hl:#ff5555,fg+:#f8f8f2,bg+:#44475a,hl+:#ff5555,info:#ffb86c,prompt:#ff5555,pointer:#ff79c6,marker:#ff79c6,spinner:#ffb86c,header:#6272a4' \
        --prompt='󰆴 Remove: ')

if [ -n "$selected_package" ]; then
    echo -e "\033[1;33m󰚰 Removing package: $selected_package\033[0m"
    sudo pacman -Rns --noconfirm "$selected_package"
    echo -e "\033[1;32m󰄬 Package removed!\033[0m"
    read -p "Press Enter to continue..."
fi
