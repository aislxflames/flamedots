#!/bin/bash

# ===============================
#           FlameDots Manager
# ===============================

# ---- CONFIG ----
BASE_DIR="$HOME/flamedots/dotfiles/" # Source of dotfiles
DEST_DIR="$HOME/"                    # Destination: your home directory
LOG_FILE="$HOME/flamedots/rsync_log.txt"

# ---- ASCII BANNER ----
banner() {
  clear
  echo -e "\e[1;31m"
  echo "
███████ ██      ███    ███      ██████  ██████  ███    ██ ███████ 
██      ██      ████  ████     ██      ██    ██ ████   ██ ██      
█████   ██      ██ ████ ██     ██      ██    ██ ██ ██  ██ █████   
██      ██      ██  ██  ██     ██      ██    ██ ██  ██ ██ ██      
██      ███████ ██      ██      ██████  ██████  ██   ████ ██  
  "
  echo "🔥 FlameDots Manager 🔥"
  echo -e "\e[0m"
  echo ""
}

# ---- SYNC FUNCTION ----
sync_files() {
  echo "$(date): Syncing files from $BASE_DIR to $DEST_DIR..." >>"$LOG_FILE"

  rsync -a --update "$BASE_DIR/" "$DEST_DIR/" >>"$LOG_FILE" 2>&1

  if [ $? -ne 0 ]; then
    echo "$(date): Error during sync." >>"$LOG_FILE"
    notify-send "🔥 Flamedots Sync" "⚠️ Sync Error! Check logs." -u critical
  else
    echo "$(date): Sync completed successfully." >>"$LOG_FILE"
    notify-send "🔥 Flamedots Sync" "✅ Sync Completed Successfully." -u normal
  fi
}

# ---- WATCH FUNCTION (background) ----
watch_and_sync() {
  while true; do
    inotifywait -r -e modify,create,delete "$BASE_DIR" >/dev/null 2>&1 && sync_files
  done
}

# ---- PACKAGE INSTALLER ----
install_packages() {
  PACKAGE_FILE="$HOME/flamedots/packages.sh"

  # Ensure yay is installed
  if ! command -v yay &>/dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg -si --noconfirm)
  fi

  mkdir -p "$HOME/flamedots"
  touch "$PACKAGE_FILE"

  # Initialize section headers if missing
  grep -qx "# Official Packages" "$PACKAGE_FILE" || echo -e "# Official Packages\n" >>"$PACKAGE_FILE"
  grep -qx "# Aur Packages" "$PACKAGE_FILE" || echo -e "\n# Aur Packages\n" >>"$PACKAGE_FILE"

  # Build package list
  official_pkgs=$(pacman -Slq | sort -u)
  aur_pkgs=$(yay -Slq aur | sort -u)
  all_pkgs=$(printf "%s\n%s" "$official_pkgs" "$aur_pkgs" | sort -u)

  while true; do
    package=$(printf "%s\n" "$all_pkgs" | fzf --height 50% --layout=reverse --border \
      --prompt="Search & Install Package: " \
      --preview="yay -Si {} | head -n 1")

    [[ -z "$package" ]] && break

    clear
    banner
    # Install if not already
    if yay -Qs "^$package\$" &>/dev/null; then
      notify-send "📦 $package" "✅ Already installed!"
    else
      yay -S "$package" --noconfirm
      notify-send "📦 $package" "✅ Installed successfully!"
    fi

    # Determine section
    if echo "$aur_pkgs" | grep -qx "$package"; then
      section="# Aur Packages"
    else
      section="# Official Packages"
    fi

    # Add package to the correct section if not already present
    if ! awk -v sec="$section" -v pkg="$package" '
            $0 == sec { in_section=1; next }
            /^#/ { in_section=0 }
            in_section && $0 == pkg { found=1 }
            END { exit !found }
        ' "$PACKAGE_FILE"; then
      tmpfile=$(mktemp)
      awk -v sec="$section" -v pkg="$package" '
                BEGIN { inserted=0 }
                {
                    print
                    if ($0 == sec && !inserted) {
                        inserted = 1
                        getline
                        print pkg
                        print
                    }
                }
                END {
                    if (!inserted) {
                        print sec
                        print pkg
                    }
                }
            ' "$PACKAGE_FILE" >"$tmpfile" && mv "$tmpfile" "$PACKAGE_FILE"
    fi
  done
}

# ---- FILE MANAGER ----
file_manager() {
  local current_dir="$BASE_DIR"

  while true; do
    cd "$current_dir" || break

    choices=$(find . -mindepth 1 -maxdepth 1 ! -name "*.png" ! -name "*.mp4" | sed 's|^\./||' | sort)
    selection=$(echo -e "🔙 BACK\n➕ New File\n📁 New Folder\n❌ Delete\n$choices" | fzf --height 50% --layout=reverse --border --prompt="Flamedots: $current_dir > ")

    [[ -z "$selection" ]] && break

    case "$selection" in
    "🔙 BACK")
      current_dir=$(dirname "$current_dir")
      ;;
    "➕ New File")
      read -rp "Enter new file name: " newfile
      touch "$current_dir/$newfile"
      ;;
    "📁 New Folder")
      read -rp "Enter new folder name: " newfolder
      mkdir -p "$current_dir/$newfolder"
      ;;
    "❌ Delete")
      target=$(find . -mindepth 1 -maxdepth 1 | sed 's|^\./||' | fzf --height 50% --layout=reverse --border --prompt="Select to Delete: ")
      [[ -n "$target" ]] && rm -rf "$current_dir/$target"
      ;;
    *)
      # If folder, go deeper
      if [[ -d "$current_dir/$selection" ]]; then
        current_dir="$current_dir/$selection"
      elif [[ -f "$current_dir/$selection" ]]; then
        editor=$(echo -e "nvim\nnano" | fzf --prompt="Choose editor: ")
        [[ "$editor" == "nvim" ]] && nvim "$selection"
        [[ "$editor" == "nano" ]] && nano "$selection"
      fi
      ;;
    esac
  done
}

# ---- Copy templates ----
copy_default_template() {
  SOURCE_DIR="$HOME"
  DEST_DIR="$HOME/flamedots/dotfiles"

  browse_directory() {
    local dir="$1"

    # Select a file/folder using fzf
    target=$(find "$dir" -mindepth 1 -maxdepth 1 | sed "s|^$HOME/|~/|" | fzf --height 50% --layout=reverse --border --prompt="Select config to open or copy: ")

    # Exit if no selection
    [[ -z "$target" ]] && {
      echo "No selection made. Aborting."
      return
    }

    # Expand ~ to full home path
    full_target="${target/#\~/$HOME}"

    # Calculate RELATIVE PATH from $HOME
    relative_path="${full_target#$HOME/}"

    # New DESTINATION path (should recreate folders inside dotfiles)
    destination="$DEST_DIR/$relative_path"

    # Choose action: Open or Copy
    action=$(echo -e "Open\nCopy" | fzf --height 50% --layout=reverse --border --prompt="Choose action: ")

    case "$action" in
    "Open")
      if [ -d "$full_target" ]; then
        browse_directory "$full_target" # If directory, open inside
      elif [ -f "$full_target" ]; then
        xdg-open "$full_target" &>/dev/null &
      fi
      ;;

    "Copy")
      # Make sure destination directory exists
      mkdir -p "$(dirname "$destination")"

      # Then copy file or folder
      cp -r "$full_target" "$destination"

      notify-send "🔥 Template Copied" "✅ Copied $relative_path to dotfiles!"
      ;;

    *)
      echo "Invalid action selected."
      ;;
    esac
  }

  # Start browsing from home
  browse_directory "$SOURCE_DIR"
}

# ---- MAIN MENU ----
main_menu() {
  clear
  banner
  while true; do
    choice=$(echo -e "🗃️ Template Copy\n🗂️  File Manager\n📦 Install Packages\n🚀 Exit" | fzf --height 50% --layout=reverse --border --prompt="Flamedots Manager: ")

    case "$choice" in

    "🗃️ Template Copy")
      copy_default_template
      ;;
    "🗂️  File Manager")
      file_manager
      ;;
    "📦 Install Packages")
      install_packages
      ;;
    "🚀 Exit")
      echo "Goodbye brh!"
      exit 0
      ;;
    esac
  done
}

# ---- BOOT ----
banner
watch_and_sync >/dev/null 2>&1 & # Background sync silently
main_menu
