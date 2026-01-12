#!/bin/bash
# Official Package installer with enhanced UI

echo -e "\033[1;36m╔══════════════════════════════════════╗\033[0m"
echo -e "\033[1;36m║        󰏖 OFFICIAL PACKAGES         ║\033[0m"
echo -e "\033[1;36m╚══════════════════════════════════════╝\033[0m"
echo

selected_packages=$(pacman -Slq | \
    fzf --multi --preview 'echo -e "\033[1;32m󰋽 Package Info:\033[0m"; pacman -Si {} 2>/dev/null || echo "No info available"' \
        --preview-window=up:60%:wrap --height=90% --border=rounded \
        --bind 'change:reload(pacman -Ss {q} | awk "/^[a-zA-Z]/ {print \$1}")' \
        --header='󰍉 Type to search • Tab to select • Enter to install • Esc to cancel' \
        --color='fg:#f8f8f2,bg:#282a36,hl:#bd93f9,fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9,info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6,marker:#ff79c6,spinner:#ffb86c,header:#6272a4' \
        --prompt='󰍉 Search: ')

if [ -n "$selected_packages" ]; then
    echo -e "\033[1;33m󰚰 Installing packages: $selected_packages\033[0m"
    sudo pacman -S --noconfirm $selected_packages
    echo -e "\033[1;32m󰄬 Installation complete!\033[0m"
    read -p "Press Enter to continue..."
fi
