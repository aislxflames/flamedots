#!/bin/bash

# Define the directory to extract to (in the home directory)
HOME_DIR="$HOME"
DIR_NAME="flamedots"
ZIP_NAME="${DIR_NAME}.zip"
REPO_URL="https://github.com/aislxflames/flamedots/archive/refs/heads/main.zip"  # Replace with your repository's URL

sudo pacman -S unzip git
# Navigate to the home directory
cd "$HOME_DIR" || exit

# Check if the directory already exists
if [ -d "$DIR_NAME" ]; then
    echo "$DIR_NAME directory already exists. Checking for updates..."

    # Navigate into the directory and pull the latest changes if it is a git repository
    if [ -d "${DIR_NAME}/.git" ]; then
        cd "$DIR_NAME" || exit
        echo "Git repository found. Pulling latest changes..."
        git pull origin main
    else
        echo "No git repository found. Skipping update."
    fi

else
    # Download the repository as a ZIP file
    echo "$DIR_NAME directory does not exist. Downloading the repository..."
    curl -L -o "$ZIP_NAME" "$REPO_URL"

    # Extract the ZIP file
    unzip "$ZIP_NAME"

    # Clean up: Remove the downloaded ZIP file
    rm "$ZIP_NAME"

    # Rename extracted folder
    mv "${DIR_NAME}-main" "$DIR_NAME"
fi

# Change to the extracted directory
cd "$DIR_NAME" || exit

# Setup completed message
echo "Setup completed."

# Check if install.sh exists and is executable, then run it
if [ -f "install.sh" ]; then
    chmod +x install.sh
    ./install.sh
else
    echo "install.sh not found in the repository."
    exit 1
fi

echo "Script completed."
