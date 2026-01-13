#!/bin/bash
# Web App creator script

TERMINAL="kitty"

# Display AsiraOS logo
echo -e "\033[1;36m"
cat asiraos-logo.txt
echo -e "\033[0m"
echo
echo -e "\033[1;32m╔══════════════════════════════════════╗\033[0m"
echo -e "\033[1;32m║           󰖟 WEB APP CREATOR         ║\033[0m"
echo -e "\033[1;32m╚══════════════════════════════════════╝\033[0m"
echo

# Get app name
echo -e "\033[1;33m󰷈 Enter App Name:\033[0m"
read -p "> " app_name

if [ -z "$app_name" ]; then
    echo -e "\033[1;31m󰅖 App name cannot be empty!\033[0m"
    read -p "Press Enter to continue..."
    exit 1
fi

# Get URL
echo -e "\033[1;33m󰖟 Enter App URL:\033[0m"
read -p "> " app_url

if [ -z "$app_url" ]; then
    echo -e "\033[1;31m󰅖 URL cannot be empty!\033[0m"
    read -p "Press Enter to continue..."
    exit 1
fi

# Get icon URL
echo -e "\033[1;33m󰏘 Enter Icon URL (PNG from dashboardicons.com):\033[0m"
read -p "> " icon_url

if [ -z "$icon_url" ]; then
    echo -e "\033[1;31m󰅖 Icon URL cannot be empty!\033[0m"
    read -p "Press Enter to continue..."
    exit 1
fi

# Create directories
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/applications/icons"

# Download icon
icon_path="$HOME/.local/share/applications/icons/${app_name}.png"
echo -e "\033[1;34m󰇚 Downloading icon...\033[0m"
curl -s -o "$icon_path" "$icon_url"

if [ $? -eq 0 ]; then
    echo -e "\033[1;32m󰄬 Icon downloaded successfully!\033[0m"
else
    echo -e "\033[1;31m󰅖 Failed to download icon!\033[0m"
    icon_path=""
fi

# Create desktop entry
desktop_file="$HOME/.local/share/applications/${app_name}.desktop"
cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Name=$app_name
Comment=$app_name
Exec=asira-launch-webapp $app_url
Terminal=false
Type=Application
Icon=$icon_path
EOF

echo -e "\033[1;32m󰸞 Web App created successfully!\033[0m"
echo -e "\033[1;36m󰉋 Desktop file: $desktop_file\033[0m"
echo -e "\033[1;36m󰏘 Icon file: $icon_path\033[0m"
echo
echo -e "\033[1;33m󰀪 Note: Make sure 'asira-launch-webapp' command exists to launch web apps\033[0m"
read -p "Press Enter to continue..."
