#!/bin/bash

CONFIG_FILE="$HOME/.ssh/ssh-manager.conf"
SSH_DIR="$HOME/.ssh"

# Colors and formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

# Center text function
center_text() {
    local text="$1"
    local width=$(tput cols)
    local padding=$(( (width - ${#text}) / 2 ))
    printf "%*s%s\n" $padding "" "$text"
}

# Header
show_header() {
    clear
    echo
    center_text "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${CYAN}${BOLD}"
    center_text "🔐 SSH CONNECTION MANAGER"
    echo -e "${NC}"
    center_text "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo
}

# Initialize config
init_config() {
    [[ ! -f "$CONFIG_FILE" ]] && touch "$CONFIG_FILE"
}

# Add server with better UI
add_server() {
    show_header
    echo -e "${YELLOW}📝 Add New Server${NC}"
    echo
    
    read -p "   Server Name: " name
    read -p "   Hostname/IP: " host
    read -p "   Username: " user
    read -p "   Port (22): " port
    
    # Use fzf to select key file
    local keyfile=""
    if [[ -d "$SSH_DIR" ]]; then
        keyfile=$(find "$SSH_DIR" -name "*.pem" -o -name "id_*" | grep -v "\.pub$" | fzf --prompt="🔑 Select SSH Key (optional): " --height=10 --border --margin=1 --padding=1)
    fi
    
    port=${port:-22}
    echo "$name|$host|$user|$port|$keyfile" >> "$CONFIG_FILE"
    echo -e "\n${GREEN}✅ Server '$name' added successfully${NC}"
    read -p "Press Enter to continue..."
}

# Enhanced server list
list_servers() {
    show_header
    [[ ! -s "$CONFIG_FILE" ]] && { 
        echo -e "${RED}❌ No servers configured${NC}"
        read -p "Press Enter to continue..."
        return
    }
    
    echo -e "${BLUE}📋 Configured Servers${NC}"
    echo
    while IFS='|' read -r name host user port keyfile; do
        echo -e "   ${CYAN}▶${NC} ${BOLD}$name${NC} → $user@$host:$port"
    done < "$CONFIG_FILE"
    echo
    read -p "Press Enter to continue..."
}

# Connect with fzf
connect() {
    [[ ! -s "$CONFIG_FILE" ]] && { 
        show_header
        echo -e "${RED}❌ No servers configured${NC}"
        read -p "Press Enter to continue..."
        return
    }
    
    local selection=$(while IFS='|' read -r name host user port keyfile; do
        echo "$name → $user@$host:$port"
    done < "$CONFIG_FILE" | fzf \
        --prompt="🚀 Connect to Server: " \
        --header="Select a server to connect via SSH" \
        --height=15 \
        --border=rounded \
        --margin=1 \
        --padding=1 \
        --color="header:italic:underline,label:blue")
    
    [[ -z "$selection" ]] && return
    
    local name=$(echo "$selection" | cut -d' ' -f1)
    
    while IFS='|' read -r sname host user port keyfile; do
        if [[ "$sname" == "$name" ]]; then
            clear
            echo -e "${GREEN}🔗 Connecting to $name...${NC}"
            cmd="ssh -p $port"
            [[ -n "$keyfile" ]] && cmd="$cmd -i $keyfile"
            exec $cmd "$user@$host"
        fi
    done < "$CONFIG_FILE"
}

# SFTP with fzf
sftp_connect() {
    [[ ! -s "$CONFIG_FILE" ]] && { 
        show_header
        echo -e "${RED}❌ No servers configured${NC}"
        read -p "Press Enter to continue..."
        return
    }
    
    local selection=$(while IFS='|' read -r name host user port keyfile; do
        echo "$name → $user@$host:$port"
    done < "$CONFIG_FILE" | fzf \
        --prompt="📁 SFTP Connection: " \
        --header="Select a server for SFTP file transfer" \
        --height=15 \
        --border=rounded \
        --margin=1 \
        --padding=1 \
        --color="header:italic:underline,label:blue")
    
    [[ -z "$selection" ]] && return
    
    local name=$(echo "$selection" | cut -d' ' -f1)
    
    while IFS='|' read -r sname host user port keyfile; do
        if [[ "$sname" == "$name" ]]; then
            clear
            echo -e "${GREEN}📂 Opening SFTP to $name...${NC}"
            cmd="sftp -P $port"
            [[ -n "$keyfile" ]] && cmd="$cmd -i $keyfile"
            exec $cmd "$user@$host"
        fi
    done < "$CONFIG_FILE"
}

# Load SSH key with fzf
load_key() {
    local keyfile=$(find "$SSH_DIR" -name "*.pem" -o -name "id_*" 2>/dev/null | grep -v "\.pub$" | fzf \
        --prompt="🔑 Load SSH Key: " \
        --header="Select an SSH key to load into ssh-agent" \
        --height=12 \
        --border=rounded \
        --margin=1 \
        --padding=1 \
        --color="header:italic:underline,label:blue")
    
    [[ -z "$keyfile" ]] && return
    [[ ! -f "$keyfile" ]] && { 
        echo -e "${RED}❌ Key file not found${NC}"
        read -p "Press Enter to continue..."
        return
    }
    
    ssh-add "$keyfile" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo -e "${GREEN}✅ Key loaded successfully${NC}"
    else
        echo -e "${RED}❌ Failed to load key${NC}"
    fi
    read -p "Press Enter to continue..."
}

# Remove server with fzf
remove_server() {
    [[ ! -s "$CONFIG_FILE" ]] && { 
        show_header
        echo -e "${RED}❌ No servers configured${NC}"
        read -p "Press Enter to continue..."
        return
    }
    
    local selection=$(while IFS='|' read -r name host user port keyfile; do
        echo "$name → $user@$host:$port"
    done < "$CONFIG_FILE" | fzf \
        --prompt="🗑️  Remove Server: " \
        --header="⚠️  Select a server to remove (this cannot be undone)" \
        --height=15 \
        --border=rounded \
        --margin=1 \
        --padding=1 \
        --color="header:italic:underline,label:red")
    
    [[ -z "$selection" ]] && return
    
    local name=$(echo "$selection" | cut -d' ' -f1)
    
    grep -v "^$name|" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    echo -e "${GREEN}✅ Server '$name' removed${NC}"
    read -p "Press Enter to continue..."
}

# Main menu with fzf
show_menu() {
    local choice=$(echo -e "📝 Add Server\n🚀 SSH Connect\n📁 SFTP Connect\n📋 List Servers\n🔑 Load SSH Key\n🗑️  Remove Server\n❌ Exit" | fzf \
        --prompt="⚡ Select Action: " \
        --header="SSH Connection Manager - Choose an option" \
        --height=12 \
        --border=rounded \
        --margin=1 \
        --padding=1 \
        --color="header:italic:underline,label:cyan")
    
    case "$choice" in
        "📝 Add Server") add_server ;;
        "🚀 SSH Connect") connect ;;
        "📁 SFTP Connect") sftp_connect ;;
        "📋 List Servers") list_servers ;;
        "🔑 Load SSH Key") load_key ;;
        "🗑️  Remove Server") remove_server ;;
        "❌ Exit"|"") exit 0 ;;
    esac
}

# Main loop
main() {
    init_config
    
    while true; do
        show_header
        show_menu
    done
}

main "$@"
