#!/bin/bash

# Step 1: System update
echo "Updating system..."
sudo pacman -Syu

# Step 2: Handle flamedots
FLAMEDOTS_DIR="$HOME/flamedots"
REPO_URL="https://github.com/aislxflames/flamedots"

if [ -d "$FLAMEDOTS_DIR" ]; then
    echo "flamedots directory exists. Fetching latest changes..."
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
        echo "Do you want to pull the latest changes?"

        if command -v fzf >/dev/null 2>&1; then
            choice=$(printf "Yes\nNo" | fzf --prompt="Select an option > " --height=5 --border --reverse)
        else
            echo -e "\n\033[1;31mfzf not installed. Falling back to basic prompt.\033[0m"
            read -p "Do you want to pull the latest changes? (y/n): " raw_choice
            if [[ "$raw_choice" == "y" || "$raw_choice" == "Y" ]]; then
                choice="Yes"
            else
                choice="No"
            fi
        fi

        if [[ "$choice" == "Yes" ]]; then
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

# Step 3: Run build.sh
BUILD_SCRIPT="$FLAMEDOTS_DIR/build.sh"
if [ -f "$BUILD_SCRIPT" ]; then
    echo "Running build.sh..."
    chmod +x "$BUILD_SCRIPT"
    "$BUILD_SCRIPT"
else
    echo "Error: build.sh not found in flamedots."
    exit 1
fi

