#!/bin/bash
set -e

# --- ASIRA SETUP FLAG ---
ASIRA_SETUP=true
if [[ "$1" == "--asira-setup" ]]; then
    ASIRA_SETUP=true
    echo "🚀 Running in Asira Setup mode: All prompts skipped, everything installed via pacman."
fi
cd ..

# --- Update system and install basic tools ---
echo "Updating system and installing dependencies..."
sudo pacman -Syu lolcat fzf --noconfirm >/dev/null 2>&1
clear

# --- FZF PROMPT FUNCTION ---
fzf_prompt() {
    local prompt="$1"
    local option1="$2"
    local option2="$3"

    if $ASIRA_SETUP; then
        echo "$option1"
        return
    fi

    choice=$(printf "$option1\n$option2" | fzf --prompt="$prompt > " --height=5 --border=none --no-sort --reverse )
    echo "$choice"
}

# --- Script Heading ---
echo "
          ░█▀█░█▀█░█▀▀░▀█▀░░░█▀▀░█▀▀░▀█▀░█░█░█▀█
          ░█▀▀░█░█░▀▀█░░█░░░░▀▀█░█▀▀░░█░░█░█░█▀▀
          ░▀░░░▀▀▀░▀▀▀░░▀░░░░▀▀▀░▀▀▀░░▀░░▀▀▀░▀░░   
                                                                 
                      AsiraOS DOTS
                  Author: Aislx FlamEs
" | lolcat

USER_HOME="/home/$(logname)"
SOURCE_CONFIG="./dotfiles/"
SOURCE_WALLPAPERS="./wallpapers"

# --- Initial Confirmation ---
choice=$(fzf_prompt "Do you want to start flamedots installation?" "Yes" "No")
if [[ "$choice" != "Yes" ]]; then
    clear
    exit
fi
echo "✅ Starting Installation..."

# --- INSTALL YAY (SKIPPED IN ASIRA MODE) ---
install_yay() {
    if $ASIRA_SETUP; then
        echo "Skipping yay install (Asira Setup mode)."
        return
    fi
    sudo chown -R $(logname):$(logname) /home/$(logname)
    sudo chown -R $(logname):$(logname) /opt
    sudo rm -rf /opt/yay
    if [ -x "$(command -v yay)" ]; then
        echo "Yay is already done. Skipping step..."
    else
        echo "Cloning yay..."
        git clone https://aur.archlinux.org/yay.git /opt/yay
        sudo chown -R $(logname):$(logname) /opt/yay
        bash -c 'cd /opt/yay && makepkg -si'
    fi
}

# --- INSTALL PACKAGES VIA PACMAN ONLY ---
install_packages() {
    echo "[*] Installing packages from ./packages.sh..."
    mapfile -t packages < <(grep -vE '^\s*#|^\s*$' ./packages.sh | tr -d '\r')
    total=${#packages[@]}
    count=0
    installed=0
    skipped=0

    for pkg in "${packages[@]}"; do
        count=$((count + 1))
        percent=$((count * 100 / total))

        if pacman -Qi "$pkg" &>/dev/null; then
            echo -e "[SKIP] $pkg already installed. [$count/$total - $percent%]"
            skipped=$((skipped + 1))
            continue
        fi

        echo -ne "[INSTALLING] $pkg [$count/$total - $percent%]..."
        if sudo pacman -S --noconfirm --needed "$pkg" &>/dev/null; then
            echo " done."
            installed=$((installed + 1))
        else
            echo " failed."
        fi
    done

    echo -e "\n[✔] Installation complete. Installed: $installed | Skipped: $skipped | Total: $total"
}

# --- INSTALL GRUB THEME ---
install_grubthemes() {
    sudo mkdir -p /boot/grub/themes/
    sudo cp -rf rootfiles/grub/Castorice /boot/grub/themes/
    sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub
    echo 'GRUB_THEME="/boot/grub/themes/Castorice/theme.txt"' | sudo tee -a /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

# --- INSTALL SDDM THEME ---
install_sddmtheme() {
    sudo cp -rf rootfiles/sddm/Candy /usr/share/sddm/themes/Candy
    sudo sed -i '/^Current=/d' /etc/sddm.conf 2>/dev/null || sudo mkdir -p /etc && echo '[Theme]' | sudo tee /etc/sddm.conf
    echo 'Current=Candy' | sudo tee -a /etc/sddm.conf
}

# --- ZSH PLUGINS & THEMES ---
install_zshplugins() {
    sudo rm -rf ~/.oh-my-zsh
    CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    touch ~/.zshrc
    sed -i '/^plugins=/,/)/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)' ~/.zshrc
    if ! grep -q "pokemon-colorscripts -r" ~/.zshrc; then
        sed -i '1s/^/pokemon-colorscripts -r\n/' ~/.zshrc
    fi
    sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|g' ~/.zshrc
    LINES_TO_ADD=(
        'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
        'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
        'source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh'
        'typeset -g POWERLEVEL9K_INSTANT_PROMPT=off'
    )
    for line in "${LINES_TO_ADD[@]}"; do
        grep -qxF "$line" ~/.zshrc || echo "$line" >> ~/.zshrc
    done
    chsh -s $(which zsh)
    cp -rf $SOURCE_CONFIG/.zshrc $USER_HOME/.zshrc
}

# --- COPY DOTFILES ---
copy_dotfiles() {
    echo "Copying .config and Wallpapers to $USER_HOME..."
    rsync -avi "$SOURCE_CONFIG" "$USER_HOME/"
    sudo cp -r rootfiles/environment /etc/environment
    sudo cp -r rootfiles/bin/asira-launch-webapp /usr/bin/
    sudo chmod +x /usr/bin/asira-launch-webapp
}

# --- HYPR PLUGINS ---
hypr_plugins() {
    if pgrep -x "Hyprland" > /dev/null; then
        hyprpm update 2>/dev/null || echo "Warning: hyprpm update failed"
        hyprpm add https://github.com/hyprwm/hyprland-plugins 2>/dev/null || echo "Warning: Failed to add hyprland-plugins"
        hyprpm enable hyprexpo 2>/dev/null || echo "Warning: Failed to enable hyprexpo"
        hyprpm enable hyprscrolling 2>/dev/null || echo "Warning: Failed to enable hyprscrolling"
        hyprpm add https://github.com/virtcode/hypr-dynamic-cursors 2>/dev/null || echo "Warning: Failed to add dynamic-cursors"
        hyprpm enable dynamic-cursors 2>/dev/null || echo "Warning: Failed to enable dynamic-cursors"
    else
        mkdir -p ~/.config/hypr
        cat > ~/.config/hypr/install-plugins.sh << 'EOF'
#!/bin/bash
hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo
hyprpm enable hyprscrolling
hyprpm add https://github.com/virtcode/hypr-dynamic-cursors
hyprpm enable dynamic-cursors
echo "Hypr plugins installed successfully"
EOF
        chmod +x ~/.config/hypr/install-plugins.sh
    fi
}

# --- EXTRA FEATURES SETUP ---
initial_setup() {
    # ~/flamedots/scripts/discord-setup.sh || true
    ~/flamedots/scripts/mpd-setup.sh || true
}

# --- REBOOT ---
reboot_system() {
    systemctl enable sddm
    systemctl enable networkmanager
    systemctl enable blueman
    echo "Rebooting..."
    reboot
}

# -------------------------
#  RUN ALL STEPS
# -------------------------
install_yay
install_packages
hypr_plugins
initial_setup
install_zshplugins
install_grubthemes
install_sddmtheme
copy_dotfiles

# Reboot
if $ASIRA_SETUP; then
    reboot_system
fi

echo "🎉 Setup completed successfully!"

