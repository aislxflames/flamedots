#!/bin/bash

# Change ownership of the home directory recursively
sudo chown -R "$USER:$USER" "$HOME"

# Navigate to home directory
cd "$HOME"

# Clone the FlameDots repository
sudo pacman -S git
git clone https://github.com/aislxflames/flamedots

# Navigate to the cloned directory
cd flamedots

# Make the install script executable
chmod +x install.sh

# Run the install script
./install.sh
