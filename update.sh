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
    exit 1
fi

# ───────────────────────────────────────────────
# Step 2: Handle flamedots
# ───────────────────────────────────────────────
FLAMEDOTS_DIR="$HOME/flamedots"
REPO_URL="https://github.com/aislxflames/flamedots"

if [ -d "$FLAMEDOTS_DIR" ]; then
    echo "📁 flamedots directory exists. Fetching latest changes..."
    git -C "$FLAMEDOTS_DIR" fetch

    LOCAL_HASH=$(git -C "$FLAMEDOTS_DIR" rev-parse HEAD)
    REMOTE_HASH=$(git -C "$FLAMEDOTS_DIR" rev-parse @{u})

    if [ "$LOCAL_HASH" != "$REMOTE_HASH" ]; then
        clear
        echo -e "\033[1;31m"
        echo "███████╗██╗      █████╗ ███╗   ███╗███████╗██████╗  ██████╗ ████████╗███████╗"
        echo "██╔════╝██║     ██╔══██╗████╗ ████║██╔════╝██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝"
        echo "███████╗██║     ███████║██╔████╔██║█████╗  ██████╔╝██║   ██║   ██║   █████╗  "
        echo "╚════██║██║     ██╔══██║██║╚██╔╝██║██╔══╝  ██╔═══╝ ██║   ██║   ██║   ██╔══╝  "
        echo "███████║███████╗██║  ██║██║ ╚═╝ ██║███████╗██║     ╚██████╔╝   ██║   ███████╗"
        echo "╚══════╝╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝      ╚═════╝    ╚═╝   ╚══════╝"
        echo -e "\033[0m"

        echo -e "\n🔥 \033[1;33mUpdate available for flamedots!\033[0m"
        # Ask the user if they want to pull the latest changes using fzf (no box style)
        pull_choice=$(fzf_prompt "Do you want to pull the latest changes for flamedots?" "Yes" "No")

        if [[ "$pull_choice" == "Yes" ]]; then
            echo "Pulling updates..."
            git -C "$FLAMEDOTS_DIR" pull
        else
            echo "Skipping flamedots update."
        fi
    else
        echo "flamedots is already up-to-date."
    fi
else
    echo "flamedots not found. Cloning from GitHub..."
    git clone "$REPO_URL" "$FLAMEDOTS_DIR"
fi

# ───────────────────────────────────────────────
# Step 3: Run build.sh
# ───────────────────────────────────────────────
BUILD_SCRIPT="$FLAMEDOTS_DIR/build.sh"
if [ -f "$BUILD_SCRIPT" ]; then
    echo "Running build.sh..."
    chmod +x "$BUILD_SCRIPT"
    cd "$FLAMEDOTS_DIR"
    "$BUILD_SCRIPT"
else
    echo "Error: build.sh not found in flamedots."
    exit 1
fi

