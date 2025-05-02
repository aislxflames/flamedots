set -e
sudo pacman -Syu lolcat --noconfirm >/dev/null 2>&1 | echo "Updating the system..."
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
" | lolcat

USER_HOME="/home/$(logname)"
SOURCE_CONFIG="./dotfiles/"
SOURCE_WALLPAPERS="./wallpapers"

read -p "Should Start Installtion? (y/n): " response
if [[ "$response" =~ ^[Yy]$ ]]; then
  echo "Start Installing"
else
  exit
fi

# Functions
go_back() {
  # Save the current working directory
  ORIG_DIR="$(pwd)"

  # Go back to the original directory
  cd "$ORIG_DIR" || exit 1
}

# Yay install function
install_yay() {
  sudo chown -R $(logname):$(logname) /opt
  if [ -d /opt/yay ]; then
    echo "Directory /opt yay is already done. Skipping step..."
  else
    echo "Cloning yay..."
    git clone https://aur.archlinux.org/yay.git /opt/yay
    sudo chown -R $(logname):$(logname) /opt/yay
    (cd /opt/yay && makepkg -si --noconfirm &>/dev/null)
  fi

}

# Install packages function
install_packages() {
  echo "[*] Installing packages from ./packages.sh..."

  # Read packages into array (ignore comments and blank lines)
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

    if yay -S --noconfirm "$pkg" &>/dev/null; then
      echo " done."
      installed=$((installed + 1))
    else
      echo " failed."
    fi
  done

  echo -e "\n[✔] Installation complete. Installed: $installed | Skipped: $skipped | Total: $total"
}

# Install grub theme
install_grubthemes() {
  sudo mkdir -p /boot/grub/themes/
  sudo cp -rf rootfiles/grub/Castorice /boot/grub/themes/Castorice
  sudo sed -i '/^GRUB_THEME=/d' /etc/default/grub && echo 'GRUB_THEME="/boot/grub/themes/Castorice/theme.txt"' | sudo tee -a /etc/default/grub
  sudo grub-mkconfig -o /boot/grub/grub.cfg
}

# Install sddm theme
install_sddmtheme() {
  sudo cp -rf rootfiles/sddm/Candy /usr/share/sddm/themes/Candy
  sudo sed -i '/^Current=/d' /etc/sddm.conf 2>/dev/null || sudo mkdir -p /etc && echo '[Theme]' | sudo tee /etc/sddm.conf
  echo 'Current=Candy' | sudo tee -a /etc/sddm.conf

}

# Install zsh plugins and themes

install_zshplugins() {
  sudo rm -rf ~/.oh-my-zsh
  CHSH=no RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  touch ~/.zshrc
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
  LINES_TO_ADD=(
    'source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme'
    'source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
    'source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh'
    'source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh'
    'typeset -g POWERLEVEL9K_INSTANT_PROMPT=off'
  )

  # Check if ZSH_THEME line exists
  if grep -q '^ZSH_THEME=' ~/.zshrc; then
    tmpfile=$(mktemp)
    inserted=0
    while IFS= read -r line; do
      echo "$line" >>"$tmpfile"
      if [[ $inserted -eq 0 && "$line" == ZSH_THEME=* ]]; then
        for add_line in "${LINES_TO_ADD[@]}"; do
          grep -qxF "$add_line" ~/.zshrc || echo "$add_line" >>"$tmpfile"
        done
        inserted=1
      fi
    done <~/.zshrc
    mv "$tmpfile" ~/.zshrc
  else
    echo "ZSH_THEME line not found in ~/.zshrc"
  fi
  echo '[ -x /bin/zsh ] && exec /bin/zsh' > ~/.bashrc
}

copy_dotfiles() {

  read -p "Do you want to copy dotfiles and wallpapers (y/n): " response # Capture user input into the response variable
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Copying .config and Wallpapers to $USER_HOME..."
    rsync -avi "./dotfiles/" "$USER_HOME/"
    #rsync -avi "$SOURCE_WALLPAPERS" "$USER_HOME/"
    echo ".config and Wallpapers copied successfully!"
    sleep 1
  else
    echo "Skipping copying files"
    sleep 1
  fi
}

# Install yay
install_yay

echo "
 ██▓ ███▄    █   ██████ ▄▄▄█████▓ ▄▄▄       ██▓     ██▓ ███▄    █   ▄████
▓██▒ ██ ▀█   █ ▒██    ▒ ▓  ██▒ ▓▒▒████▄    ▓██▒    ▓██▒ ██ ▀█   █  ██▒ ▀█▒
▒██▒▓██  ▀█ ██▒░ ▓██▄   ▒ ▓██░ ▒░▒██  ▀█▄  ▒██░    ▒██▒▓██  ▀█ ██▒▒██░▄▄▄░
░██░▓██▒  ▐▌██▒  ▒   ██▒░ ▓██▓ ░ ░██▄▄▄▄██ ▒██░    ░██░▓██▒  ▐▌██▒░▓█  ██▓
░██░▒██░   ▓██░▒██████▒▒  ▒██▒ ░  ▓█   ▓██▒░██████▒░██░▒██░   ▓██░░▒▓███▀▒
░▓  ░ ▒░   ▒ ▒ ▒ ▒▓▒ ▒ ░  ▒ ░░    ▒▒   ▓▒█░░ ▒░▓  ░░▓  ░ ▒░   ▒ ▒  ░▒   ▒
 ▒ ░░ ░░   ░ ▒░░ ░▒  ░ ░    ░      ▒   ▒▒ ░░ ░ ▒  ░ ▒ ░░ ░░   ░ ▒░  ░   ░
 ▒ ░   ░   ░ ░ ░  ░  ░    ░        ░   ▒     ░ ░    ▒ ░   ░   ░ ░ ░ ░   ░
 ░           ░       ░                 ░  ░    ░  ░ ░           ░       ░
" | lolcat
install_packages
copy_dotfiles
install_zshplugins
install_grubthemes
install_sddmtheme
