#!/bin/bash

# ───────────────────────────────────────────────
# Function to show fzf prompt with two options in the middle
# ───────────────────────────────────────────────
function fzf_prompt() {
    local prompt="$1"
    local option1="$2"
    local option2="$3"
    
    # Create the fzf prompt with only two options and centered
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

# Ask the user if they want to update the system using fzf (no box style)
choice=$(fzf_prompt "Do you want to update the system?" "Yes" "No")

if [[ "$choice" == "Yes" ]]; then
    echo "📦 Updating system..."
    
    # Capture the list of packages to be updated
    pacman -Qu | tee /tmp/updates.log | awk '{print $1}' > /tmp/update-packages.txt
    
    total_updates=$(wc -l < /tmp/update-packages.txt)
    current_update=0

    # Run pacman update with a custom progress indicator
    sudo pacman -Syu --noconfirm --quiet --needed | while read -r line; do
        # Extract the package name from pacman output and update progress
        if [[ "$line" =~ "resolving dependencies..." ]]; then
            continue
        fi
        
        if [[ "$line" =~ "Packages to be updated" ]]; then
            continue
        fi

        if [[ "$line" =~ "Packages updated" ]]; then
            continue
        fi

        current_update=$((current_update + 1))
        if [ "$total_updates" -gt 0 ]; then
            percent=$(( 100 * current_update / total_updates ))
        else
            percent=100
        fi
        
        # Use dialog to show the progress bar
    done
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

if [[ "$choice" == "Yes" ]]; then
  echo "Flamedots Update Starting...."
else
  echo "Closing"
  exit 0
fi

if [ -d "$FLAMEDOTS_DIR" ]; then
    echo "📁 flamedots directory exists. Updating..."
    
    # Check if there are uncommitted changes
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
    
    # Force update from remote
    echo "🔄 Forcing update from remote repository..."
    git -C "$FLAMEDOTS_DIR" fetch --all
    git -C "$FLAMEDOTS_DIR" reset --hard origin/main
    
    echo "✅ flamedots successfully updated to latest version!"
else
    echo "📥 flamedots not found. Cloning from GitHub..."
    git clone "$REPO_URL" "$FLAMEDOTS_DIR"
    echo "✅ flamedots successfully cloned!"
fi

# ───────────────────────────────────────────────
# Step 3: Run build.sh
# ───────────────────────────────────────────────
BUILD_SCRIPT="$FLAMEDOTS_DIR/build.sh"
if [ -f "$BUILD_SCRIPT" ]; then
    echo "🔨 Running build.sh..."
    chmod +x "$BUILD_SCRIPT"
    cd "$FLAMEDOTS_DIR"
    
    # Ask if user wants to run build script
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
