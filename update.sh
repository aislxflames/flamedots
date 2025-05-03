#!/bin/bash

# ───────────────────────────────────────────────
# Function to show fzf prompt with two options in the middle
# ───────────────────────────────────────────────
function fzf_prompt() {
    local prompt="$1"
    local option1="$2"
    local option2="$3"
    
    choice=$(printf "$option1\n$option2" | fzf --prompt="$prompt > " --height=5 --border=none --no-sort --reverse )
    echo "$choice"
}

# ───────────────────────────────────────────────
# Step 1: System update
# ───────────────────────────────────────────────
clear
echo "
  ██████▓██   ██▓  ██████     █    ██  ██▓███  ▓█████▄  ▄▄▄     ▄▄▄█████▓▓█████ 
▒██    ▒ ▒██  ██▒▒██    ▒     ██  ▓██▒▓██░  ██▒▒██▀ ██▌▒████▄   ▓  ██▒ ▓▒▓█   ▀ 
░ ▓██▄    ▒██ ██░░ ▓██▄      ▓██  ▒██░▓██░ ██▓▒░██   █▌▒██  ▀█▄ ▒ ▓██░ ▒░▒███   
  ▒   ██▒ ░ ▐██▓░  ▒   ██▒   ▓▓█  ░██░▒██▄█▓▒ ▒░▓█▄   ▌░██▄▄▄▄██░ ▓██▓ ░ ▒▓█  ▄ 
▒██████▒▒ ░ ██▒▓░▒██████▒▒   ▒▒█████▓ ▒██▒ ░  ░░▒████▓  ▓█   ▓██▒ ▒██▒ ░ ░▒████▒
▒ ▒▓▒ ▒ ░  ██▒▒▒ ▒ ▒▓▒ ▒ ░   ░▒▓▒ ▒ ▒ ▒▓▒░ ░  ░ ▒▒▓  ▒  ▒▒   ▓▒█░ ▒ ░░   ░░ ▒░ ░
░ ░▒  ░ ░▓██ ░▒░ ░ ░▒  ░ ░   ░░▒░ ░ ░ ░▒ ░      ░ ▒  ▒   ▒   ▒▒ ░   ░     ░ ░  ░
░  ░  ░  ▒ ▒ ░░  ░  ░  ░      ░░░ ░ ░ ░░        ░ ░  ░   ░   ▒    ░         ░   
      ░  ░ ░           ░        ░                 ░          ░  ░           ░  ░
         ░ ░                                    ░
" | lolcat
echo "🔧 System Update"

choice=$(fzf_prompt "Do you want to update the system?" "Yes" "No")

if [[ "$choice" == "Yes" ]]; then
    echo "📦 Updating system..."
    pacman -Qu | tee /tmp/updates.log | awk '{print $1}' > /tmp/update-packages.txt
    total_updates=$(wc -l < /tmp/update-packages.txt)
    current_update=0

    sudo pacman -Syu --noconfirm --quiet --needed
else
    echo "❌ Skipping system update."
    sleep 1
fi

# ───────────────────────────────────────────────
# Step 2: Handle flamedots
# ───────────────────────────────────────────────
FLAMEDOTS_DIR="$HOME/flamedots"
REPO_URL="https://github.com/aislxflames/flamedots"

clear
echo "
  █████▒██▓    ▄▄▄       ███▄ ▄███▓▓█████     █    ██  ██▓███  ▓█████▄  ▄▄▄     ▄▄▄█████▓▓█████ 
▓██   ▒▓██▒   ▒████▄    ▓██▒▀█▀ ██▒▓█   ▀     ██  ▓██▒▓██░  ██▒▒██▀ ██▌▒████▄   ▓  ██▒ ▓▒▓█   ▀ 
▒████ ░▒██░   ▒██  ▀█▄  ▓██    ▓██░▒███      ▓██  ▒██░▓██░ ██▓▒░██   █▌▒██  ▀█▄ ▒ ▓██░ ▒░▒███   
░▓█▒  ░▒██░   ░██▄▄▄▄██ ▒██    ▒██ ▒▓█  ▄    ▓▓█  ░██░▒██▄█▓▒ ▒░▓█▄   ▌░██▄▄▄▄██░ ▓██▓ ░ ▒▓█  ▄ 
░▒█░   ░██████▒▓█   ▓██▒▒██▒   ░██▒░▒████▒   ▒▒█████▓ ▒██▒ ░  ░░▒████▓  ▓█   ▓██▒ ▒██▒ ░ ░▒████▒
 ▒ ░   ░ ▒░▓  ░▒▒   ▓▒█░░ ▒░   ░  ░░░ ▒░ ░   ░▒▓▒ ▒ ▒ ▒▓▒░ ░  ░ ▒▒▓  ▒  ▒▒   ▓▒█░ ▒ ░░   ░░ ▒░ ░
 ░     ░ ░ ▒  ░ ▒   ▒▒ ░░  ░      ░ ░ ░  ░   ░░▒░ ░ ░ ░▒ ░      ░ ▒  ▒   ▒   ▒▒ ░   ░     ░ ░  ░
 ░ ░     ░ ░    ░   ▒   ░      ░      ░       ░░░ ░ ░ ░░        ░ ░  ░   ░   ▒    ░         ░   
           ░  ░     ░  ░       ░      ░  ░      ░                 ░          ░  ░           ░  ░
                                                                ░ 
" | lolcat

echo "🔧 Flamedots Update"

choice=$(fzf_prompt "Do you want to update dotfiles of flamedots?" "Yes" "No")

if [[ "$choice" != "Yes" ]]; then
  echo "Closing"
  exit 0
fi

if [ -d "$FLAMEDOTS_DIR" ]; then
    echo "📁 flamedots directory exists. Updating..."
    
    if [ -n "$(git -C "$FLAMEDOTS_DIR" status --porcelain)" ]; then
        echo "⚠️  Local changes detected in flamedots directory"
        stash_choice=$(fzf_prompt "Stash local changes before updating?" "Yes" "No")
        
        if [[ "$stash_choice" == "Yes" ]]; then
            echo "Stashing local changes..."
            git -C "$FLAMEDOTS_DIR" stash
        else
            echo "Proceeding with update (local changes may be overwritten)..."
        fi
    fi

    echo "🔄 Switching to 'flamedotsv2' branch and forcing update from remote..."
    git -C "$FLAMEDOTS_DIR" fetch origin flamedotsv2
    git -C "$FLAMEDOTS_DIR" checkout -B flamedotsv2 origin/flamedotsv2
    git -C "$FLAMEDOTS_DIR" reset --hard origin/flamedotsv2

    echo "✅ flamedots successfully updated to 'flamedotsv2'!"
else
    echo "📥 flamedots not found. Cloning from GitHub..."
    git clone -b flamedotsv2 "$REPO_URL" "$FLAMEDOTS_DIR"
    echo "✅ flamedots successfully cloned from 'flamedotsv2' branch!"
fi

# ───────────────────────────────────────────────
# Step 3: Run build.sh
# ───────────────────────────────────────────────
BUILD_SCRIPT="$FLAMEDOTS_DIR/build.sh"
if [ -f "$BUILD_SCRIPT" ]; then
    echo "🔨 Running build.sh..."
    chmod +x "$BUILD_SCRIPT"
    cd "$FLAMEDOTS_DIR"
    
    build_choice=$(fzf_prompt "Run the build script now?" "Yes" "No")
    
    if [[ "$build_choice" == "Yes" ]]; then
        "$BUILD_SCRIPT"
        echo "✅ Build completed successfully!"
    else
        echo "❌ Skipping build process."
    fi
else
    echo "❌ Error: build.sh not found in flamedots."
    exit 1
fi

echo "🎉 All operations completed!"

