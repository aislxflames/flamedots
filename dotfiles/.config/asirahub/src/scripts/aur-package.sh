#!/bin/bash
# AUR Package installer with enhanced UI

echo -e "\033[1;35m╔══════════════════════════════════════╗\033[0m"
echo -e "\033[1;35m║           󰏗 AUR PACKAGES           ║\033[0m"
echo -e "\033[1;35m╚══════════════════════════════════════╝\033[0m"
echo

selected_packages=$(yay -Slq | \
    fzf --multi --preview 'echo -e "\033[1;32m󰋽 Package Info:\033[0m"; yay -Si {} 2>/dev/null || echo "No info available"' \
        --preview-window=up:60%:wrap --height=90% --border=rounded \
        --bind 'change:reload(yay -Ss {q} | awk "/^[a-zA-Z]/ {print \$1}")' \
        --header='󰍉 Type to search • Tab to select • Enter to install • Esc to cancel' \
        --color='fg:#f8f8f2,bg:#282a36,hl:#ff79c6,fg+:#f8f8f2,bg+:#44475a,hl+:#ff79c6,info:#ffb86c,prompt:#bd93f9,pointer:#50fa7b,marker:#50fa7b,spinner:#ffb86c,header:#6272a4' \
        --prompt='󰍉 Search: ' \
        --query='')

if [ -n "$selected_packages" ]; then
    echo -e "\033[1;33m󰚰 Installing from AUR: $selected_packages\033[0m"
    yay -S --noconfirm $selected_packages
    echo -e "\033[1;32m󰄬 Installation complete!\033[0m"
    read -p "Press Enter to continue..."
fi
