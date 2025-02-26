#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e
pacman -Syu lolcat ttf-jetbrains-mono-nerd --noconfirm  > /dev/null 2>&1 | echo "Updating the system..."
clear

# Display script heading
echo "
  █████▒██▓    ▄▄▄       ███▄ ▄███▓▓█████     ▒█████    ██████
▓██   ▒▓██▒   ▒████▄    ▓██▒▀█▀ ██▒▓█   ▀    ▒██▒  ██▒▒██    ▒
▒████ ░▒██░   ▒██  ▀█▄  ▓██    ▓██░▒███      ▒██░  ██▒░ ▓██▄
░▓█▒  ░▒██░   ░██▄▄▄▄██ ▒██    ▒██ ▒▓█  ▄    ▒██   ██░  ▒   ██▒
░▒█░   ░██████▒▓█   ▓██▒▒██▒   ░██▒░▒████▒   ░ ████▓▒░▒██████▒▒
 ▒ ░   ░ ▒░▓  ░▒▒   ▓▒█░░ ▒░   ░  ░░░ ▒░ ░   ░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░
 ░     ░ ░ ▒  ░ ▒   ▒▒ ░░  ░      ░ ░ ░  ░     ░ ▒ ▒░ ░ ░▒  ░ ░
 ░ ░     ░ ░    ░   ▒   ░      ░      ░      ░ ░ ░ ▒  ░  ░  ░
           ░  ░     ░  ░       ░      ░  ░       ░ ░        ░  
                Welcome to FlamEs OS Setup!            
                    FlamEs OS Setup                  
                    Author: Aislx FlamEs                
"| lolcat

    USER_HOME="/home/$(logname)"
    SOURCE_CONFIG="./dotfiles/"
    SOURCE_WALLPAPERS="./wallpapers"

read -p "Should Start Installtion? (y/n): " response  # Capture user input again into the response variable
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Start Installing" # Exit the script if user chooses 'y' or 'Y'
else
    exit
fi
install_yay(){
	sudo chown -R $(logname):$(logname) /opt
	if [-d /opt/yay]; then
	 echo "Directory /opt yay is already done. Skipping step..."
	else
		echo "Cloning yay..."
		git clone https://aur.archlinux.org/yay.git /opt/yay
	fi
	sudo chown -R $(logname):$(logname) /opt/yay
	cd /opt/yay
	makepkg -si --noconfirm
}


# List of packages to install
packages=(
    swww
    amberol
    hyprpaper
    pyprland
    network-manager-applet
    sddm
    sddm-sugar-candy-git
    zsh
    zsh-history-substring-search
    zsh-syntax-highlighting
    zsh-autosuggestions
    imagemagick
    flatpak
    ttf-meslo-nerd-font-powerlevel10k
    rofi-wayland
    swaync
    rofi-emoji-git
    pamac-all
    ocs-url
    libgbinder
    xdg-desktop-portal-hyprland
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    gnome-clocks
    hyprland
    waybar
    waypaper
    thunar
    firefox
    pavucontrol
    neofetch
    cava
    neo-matrix
    tty-clock
    cliphist
    rofimoji
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    drun
    alacritty
    vim
    nano
    pywal
    gtk
    gnome-themes-standard
    sassc
    rsync
    nwg-look
    nwg-dock-hyprland
    pokemon-colorscripts-git
    blueman
    bluez
    polkit
    polkit-gnome
    feh
    wl-clipboard
    xdg-user-dirs
    xdg-user-dirs-gtk
    btop
)

# Function to install missing packages
install_missing_packages() {
    missing_packages=()

    clear
echo  "
 ██▓ ███▄    █   ██████ ▄▄▄█████▓ ▄▄▄       ██▓     ██▓ ███▄    █   ▄████
▓██▒ ██ ▀█   █ ▒██    ▒ ▓  ██▒ ▓▒▒████▄    ▓██▒    ▓██▒ ██ ▀█   █  ██▒ ▀█▒
▒██▒▓██  ▀█ ██▒░ ▓██▄   ▒ ▓██░ ▒░▒██  ▀█▄  ▒██░    ▒██▒▓██  ▀█ ██▒▒██░▄▄▄░
░██░▓██▒  ▐▌██▒  ▒   ██▒░ ▓██▓ ░ ░██▄▄▄▄██ ▒██░    ░██░▓██▒  ▐▌██▒░▓█  ██▓
░██░▒██░   ▓██░▒██████▒▒  ▒██▒ ░  ▓█   ▓██▒░██████▒░██░▒██░   ▓██░░▒▓███▀▒
░▓  ░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░  ▒ ░░    ▒▒   ▓▒█░░ ▒░▓  ░░▓  ░ ▒░   ▒ ▒  ░▒   ▒
 ▒ ░░ ░░   ░ ▒░░ ░▒  ░ ░    ░      ▒   ▒▒ ░░ ░ ▒  ░ ▒ ░░ ░░   ░ ▒░  ░   ░
 ▒ ░   ░   ░ ░ ░  ░  ░    ░        ░   ▒     ░ ░    ▒ ░   ░   ░ ░ ░ ░   ░
 ░           ░       ░                 ░  ░    ░  ░ ░           ░       ░
"| lolcat

    # Check for each package if it's installed
    for pkg in "${packages[@]}"; do
        if ! pacman -Qi "$pkg" &> /dev/null && ! yay -Qi "$pkg" &> /dev/null; then
            missing_packages+=("$pkg")
        fi
    done

    # Install missing packages
    if [ ${#missing_packages[@]} -gt 0 ]; then
        echo "Installing missing packages..."
        for pkg in "${missing_packages[@]}"; do
            echo "Installing $pkg..."
            yay -S --needed --noconfirm "$pkg"
        done
        echo "Missing packages have been successfully installed!"
    else
        echo "All packages are already installed and up-to-date!"
            sleep 1
    fi
}

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "yay is not installed. Installing yay..."
    install_yay
else
    echo "yay is already installed. Skipping installation."
fi

# Update the system and install any missing packages

install_missing_packages
clear
echo "
▓█████▄  ▒█████  ▄▄▄█████▓     █████▒██▓ ██▓    ▓█████   ██████
▒██▀ ██▌▒██▒  ██▒▓  ██▒ ▓▒   ▓██   ▒▓██▒▓██▒    ▓█   ▀ ▒██    ▒
░██   █▌▒██░  ██▒▒ ▓██░ ▒░   ▒████ ░▒██▒▒██░    ▒███   ░ ▓██▄
░▓█▄   ▌▒██   ██░░ ▓██▓ ░    ░▓█▒  ░░██░▒██░    ▒▓█  ▄   ▒   ██▒
░▒████▓ ░ ████▓▒░  ▒██▒ ░    ░▒█░   ░██░░██████▒░▒████▒▒██████▒▒
 ▒▒▓  ▒ ░ ▒░▒░▒░   ▒ ░░       ▒ ░   ░▓  ░ ▒░▓  ░░░ ▒░ ░▒ ▒▓▒ ▒ ░
 ░ ▒  ▒   ░ ▒ ▒░     ░        ░      ▒ ░░ ░ ▒  ░ ░ ░  ░░ ░▒  ░ ░
 ░ ░  ░ ░ ░ ░ ▒    ░          ░ ░    ▒ ░  ░ ░      ░   ░  ░  ░
   ░        ░ ░                      ░      ░  ░   ░  ░      ░
 ░
"| lolcat

# Ask if user wants to copy dotfiles and wallpapers
read -p "Do you want to copy dotfiles and wallpapers (y/n): " response  # Capture user input into the response variable
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Copying .config and Wallpapers to $USER_HOME..."
    rsync -avi "$SOURCE_CONFIG" "$USER_HOME/"
    rsync -avi "$SOURCE_WALLPAPERS" "$USER_HOME/"
    echo ".config and Wallpapers copied successfully!"
    sleep 1
else 
    echo "Skipping copying files"
    sleep 1
fi

# Ask if user wants to install oh my zsh and login manager
clear
echo "
 ▄████▄   ▒█████   ███▄    █ ▄▄▄█████▓ ██▓ ███▄    █  █    ██ ▓█████
▒██▀ ▀█  ▒██▒  ██▒ ██ ▀█   █ ▓  ██▒ ▓▒▓██▒ ██ ▀█   █  ██  ▓██▒▓█   ▀
▒▓█    ▄ ▒██░  ██▒▓██  ▀█ ██▒▒ ▓██░ ▒░▒██▒▓██  ▀█ ██▒▓██  ▒██░▒███
▒▓▓▄ ▄██▒▒██   ██░▓██▒  ▐▌██▒░ ▓██▓ ░ ░██░▓██▒  ▐▌██▒▓▓█  ░██░▒▓█  ▄
▒ ▓███▀ ░░ ████▓▒░▒██░   ▓██░  ▒██▒ ░ ░██░▒██░   ▓██░▒▒█████▓ ░▒████▒
░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒   ▒ ░░   ░▓  ░ ▒░   ▒ ▒ ░▒▓▒ ▒ ▒ ░░ ▒░ ░
  ░  ▒     ░ ▒ ▒░ ░ ░░   ░ ▒░    ░     ▒ ░░ ░░   ░ ▒░░░▒░ ░ ░  ░ ░  ░
░        ░ ░ ░ ▒     ░   ░ ░   ░       ▒ ░   ░   ░ ░  ░░░ ░ ░    ░
░ ░          ░ ░           ░           ░           ░    ░        ░  ░
░
" | lolcat

read -p "Do you wanna continue setup? (y/n): " response  # Capture user input again into the response variable
if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Continuing" # Exit the script if user chooses 'y' or 'Y'
else
    exit
fi

echo "Installing plugins"
sed -i '/^plugins=/,/)/c\plugins=(\n  git\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n \n zsh-history-substring-search)' ~/.zshrc
echo "Setup pokemon colorscripts"
if ! grep -q "pokemon-colorscripts -r" ~/.zshrc; then
    sed -i '1s/^/pokemon-colorscripts -r\n/' ~/.zshrc
    echo "Added pokemon-colorscripts -r to the beginning of ~/.zshrc"
else
    echo "pokemon-colorscripts -r already exists in ~/.zshrc. Skipping."
fi
# Check if ~/powerlevel10k exists and remove it if it does
if [ -d "$USER_HOME/powerlevel10k" ]; then
    echo "Removing ~/powerlevel10k..."
    sudo rm -r ~/powerlevel10k
else
    echo "~/powerlevel10k does not exist, skipping removal."
fi

# Check if ~/oh-my-zsh/custom/themes/powerlevel10k exists and remove it if it does
if [ -d "$USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Removing ~/oh-my-zsh/custom/themes/powerlevel10k..."
    sudo rm -r ~/.oh-my-zsh/custom/themes/powerlevel10k
else
    echo "~/.oh-my-zsh/custom/themes/powerlevel10k does not exist, skipping removal."
fi

# Check if ~/powerlevel10k exists and remove it if it does
if [ ! -d "$USER_HOME/powerlevel10k" ]; then
    echo "Cloning powerlevel10k repository..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $USER_HOME/.oh-my-zsh/custom/themes/powerlevel10k
else
    echo "$USER_HOME/powerlevel10k already exists, skipping clone."
fi
sed -i 's|ZSH_THEME="robbyrussell"|ZSH_THEME="powerlevel10k/powerlevel10k"|g' ~/.zshrc

# Ensure the source directories exist

if [ ! -d "$USER_HOME/.config" ]; then
    mkdir -p "$USER_HOME/.config"
    echo "Created .config directory at $USER_HOME"
fi

if [ -d "$USER_HOME/.config" ]; then
    rsync -av --ignore-existing "$SOURCE_CONFIG/" "$USER_HOME/.config/"
    echo "Synced .config to $USER_HOME"
else
    echo "Warning: $SOURCE_CONFIG directory does not exist. Skipping .config copy."
fi

if [ ! -d "$USER_HOME/Wallpapers" ]; then
    mkdir -p "$USER_HOME/Wallpapers"
    echo "Created Wallpapers directory at $USER_HOME"
fi

if [ -d "$USER_HOME/Wallpapers"  ]; then
    rsync -av --ignore-existing "$SOURCE_WALLPAPERS/" "$USER_HOME/Wallpapers/"
    echo "Synced Wallpapers to $USER_HOME"
else
    echo "Warning: $SOURCE_WALLPAPERS directory does not exist. Skipping Wallpapers copy."
fi
echo "Setup complete! Enjoy your FlamEs Hyprdots!"

echo "Installing gtk themes"
if [ ! -d /opt/Graphite-gtk-theme ]; then
  sudo git clone https://github.com/vinceliuice/Graphite-gtk-theme.git /opt/Graphite-gtk-theme
else
  echo "/opt/Graphite-gtk-theme already exists, skipping clone."
fi
sudo /opt/Graphite-gtk-theme/install.sh  -d ~/.themes/ -t -c dark -s standard -l --tweaks darker rimless

# Check if bluetooth is already enabled

if systemctl is-enabled --quiet bluetooth; then
    echo "bluetooth is already enabled, skipping."
else
    echo "Enabling bluetooth..."
    sudo systemctl enable bluetooth
    sudo systemctl start bluetooth  # Optionally, start the service immediately
    echo "bluetooth has been enabled and started."
fi

# Check if sddm is already enabled

if systemctl is-enabled --quiet sddm; then
    echo "sddm is already enabled, skipping."
else
    echo "Enabling sddm..."
    sudo systemctl enable sddm
    echo "sddm has been enabled and started."
fi

echo "Setting POWERLEVEL9K_INSTANT_PROMPT=off"
# Check if POWERLEVEL9K_INSTANT_PROMPT=off is already in ~/.zshrc

if ! grep -q "typeset -g POWERLEVEL9K_INSTANT_PROMPT=off" ~/.zshrc; then
    # If not found, append it to the very last line of ~/.zshrc using sed
    sed -i -e '$a\' -e 'typeset -g POWERLEVEL9K_INSTANT_PROMPT=off' ~/.zshrc
    echo "Added typeset -g POWERLEVEL9K_INSTANT_PROMPT=off to the bottom of ~/.zshrc"
else
    echo "POWERLEVEL9K_INSTANT_PROMPT=off already exists in ~/.zshrc. Skipping."
fi
# Ask the user if they want to reboot the system
clear
echo "
 ▄▄▄      ▓█████▄  ██▓▄▄▄█████▓ ██▓ ▒█████   ███▄    █  ▄▄▄       ██▓
▒████▄    ▒██▀ ██▌▓██▒▓  ██▒ ▓▒▓██▒▒██▒  ██▒ ██ ▀█   █ ▒████▄    ▓██▒
▒██  ▀█▄  ░██   █▌▒██▒▒ ▓██░ ▒░▒██▒▒██░  ██▒▓██  ▀█ ██▒▒██  ▀█▄  ▒██░
░██▄▄▄▄██ ░▓█▄   ▌░██░░ ▓██▓ ░ ░██░▒██   ██░▓██▒  ▐▌██▒░██▄▄▄▄██ ▒██░
 ▓█   ▓██▒░▒████▓ ░██░  ▒██▒ ░ ░██░░ ████▓▒░▒██░   ▓██░ ▓█   ▓██▒░██████▒
 ▒▒   ▓▒█░ ▒▒▓  ▒ ░▓    ▒ ░░   ░▓  ░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ▒▒   ▓▒█░░ ▒░▓  ░
  ▒   ▒▒ ░ ░ ▒  ▒  ▒ ░    ░     ▒ ░  ░ ▒ ▒░ ░ ░░   ░ ▒░  ▒   ▒▒ ░░ ░ ▒  ░
  ░   ▒    ░ ░  ░  ▒ ░  ░       ▒ ░░ ░ ░ ▒     ░   ░ ░   ░   ▒     ░ ░
      ░  ░   ░     ░            ░      ░ ░           ░       ░  ░    ░  ░
           ░
"| lolcat
    # Ask if the user wants to install additional packages (sddm-theme-sugar-candy-git, visual-studio-bin)
    read -p "Do you want to install the additional packages (vesktop(discord),brave,vscod etc.)? (y/n): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        yay -S visual-studio-bin vesktop brave
        echo "Additional packages installed: vesktop(discord),brave,vscod etc."
    else
        echo "No additional packages installed."
    fi

    # Copy .config and Wallpapers directories to the home directory
clear
echo "
  ▄████  ██▀███   █    ██  ▄▄▄▄
 ██▒ ▀█▒▓██ ▒ ██▒ ██  ▓██▒▓█████▄
▒██░▄▄▄░▓██ ░▄█ ▒▓██  ▒██░▒██▒ ▄██
░▓█  ██▓▒██▀▀█▄  ▓▓█  ░██░▒██░█▀
░▒▓███▀▒░██▓ ▒██▒▒▒█████▓ ░▓█  ▀█▓
 ░▒   ▒ ░ ▒▓ ░▒▓░░▒▓▒ ▒ ▒ ░▒▓███▀▒
  ░   ░   ░▒ ░ ▒░░░▒░ ░ ░ ▒░▒   ░
░ ░   ░   ░░   ░  ░░░ ░ ░  ░    ░
      ░    ░        ░      ░
                                ░
" | lolcat
    read -p "You want custom grub theme (sddm included)? (y/n): " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        sudo ./custom-configs/grub/install.sh
        sudo cp -r ./custom-configs/sddm/sddm.conf /etc/sddm.conf
        echo "Grub theme successfully installed!"
    else
        echo "Grub theme installation skipped."
    fi
clear
echo "
  █████▒██▓ ███▄    █  ██▓  ██████  ██░ ██ ▓█████ ▓█████▄
▓██   ▒▓██▒ ██ ▀█   █ ▓██▒▒██    ▒ ▓██░ ██▒▓█   ▀ ▒██▀ ██▌
▒████ ░▒██▒▓██  ▀█ ██▒▒██▒░ ▓██▄   ▒██▀▀██░▒███   ░██   █▌
░▓█▒  ░░██░▓██▒  ▐▌██▒░██░  ▒   ██▒░▓█ ░██ ▒▓█  ▄ ░▓█▄   ▌
░▒█░   ░██░▒██░   ▓██░░██░▒██████▒▒░▓█▒░██▓░▒████▒░▒████▓
 ▒ ░   ░▓  ░ ▒░   ▒ ▒ ░▓  ▒ ▒▓▒ ▒ ░ ▒ ░░▒░▒░░ ▒░ ░ ▒▒▓  ▒
 ░      ▒ ░░ ░░   ░ ▒░ ▒ ░░ ░▒  ░ ░ ▒ ░▒░ ░ ░ ░  ░ ░ ▒  ▒
 ░ ░    ▒ ░   ░   ░ ░  ▒ ░░  ░  ░   ░  ░░ ░   ░    ░ ░  ░
        ░           ░  ░        ░   ░  ░  ░   ░  ░   ░
                                                   ░
"| lolcat

read -p "Do you want to reboot your system now? (y/n): " choice
case "$choice" in
    y|Y ) 
        echo "Rebooting the system..."
        reboot
        ;;
    n|N )
        echo "Reboot skipped. You may need to reboot later to apply all changes."
        ;;
    * )
        echo "Invalid choice. Reboot skipped. Please reboot manually if needed."
        ;;
esac


