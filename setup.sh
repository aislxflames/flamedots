#!/bin/bash

# Define the GitHub repository URL and the ZIP file URL
REPO_URL="https://github.com/aislxflames/flamedots"
ZIP_URL="${REPO_URL}/archive/refs/heads/main.zip"

# Define the directory to extract to (in the home directory)
HOME_DIR="$HOME"
DIR_NAME="flamedots"

# Navigate to the home directory
cd "$HOME_DIR" || exit

# Download the repository as a ZIP file
curl -L -o "${DIR_NAME}.zip" "$ZIP_URL"

# Extract the ZIP file
unzip "${DIR_NAME}.zip"

# Clean up: Remove the downloaded ZIP file
rm "${DIR_NAME}.zip"

# Change to the extracted directory
cd "${DIR_NAME}-main" || exit

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

