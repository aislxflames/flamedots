#!/bin/bash
set -e

# Constants
readonly WALLPAPER_BASE="$HOME/.config/flames/wallpaper"
readonly HISTORY_FILE="$HOME/.config/flames/.wallpaper_history"
readonly PROTECTED_THEMES=("dark-default" "light-default")

# Check if theme is protected
is_protected_theme() {
  for protected in "${PROTECTED_THEMES[@]}"; do
    [[ "$1" == "$protected" ]] && return 0
  done
  return 1
}

# Save to history
save_history() {
  mkdir -p "$(dirname "$HISTORY_FILE")"
  touch "$HISTORY_FILE"
  grep -vFx "$1" "$HISTORY_FILE" > "$HISTORY_FILE.tmp" || true
  echo "$1" >> "$HISTORY_FILE.tmp"
  mv "$HISTORY_FILE.tmp" "$HISTORY_FILE"
}

# Get history list
get_history() {
  [[ -f "$HISTORY_FILE" ]] && tac "$HISTORY_FILE" || true
}

# Theme Selection
chosen_theme=$(printf "⛳ Wallpaper Theme\n🗑️ Delete Theme Folder\n✏️ Rename Theme Folder\n🖼️ Rename/Delete Wallpaper" | \
  fzf --prompt="⚙️ Action: " --layout=reverse --border --height=40%)

case "$chosen_theme" in
  "⛳ Wallpaper Theme")
    ;;

  "🗑️ Delete Theme Folder")
    folders=$(find "$WALLPAPER_BASE" -mindepth 1 -maxdepth 1 -type d | sed "s|$WALLPAPER_BASE/||")
    folder_to_delete=$(printf "%s\n" "$folders" | fzf --prompt="🗑️ Delete which theme? ")
    is_protected_theme "$folder_to_delete" && echo "❌ Cannot delete protected theme." && exit 1
    [[ -n "$folder_to_delete" ]] && rm -rf "$WALLPAPER_BASE/$folder_to_delete" && echo "✅ Deleted $folder_to_delete"
    exit 0
    ;;

  "✏️ Rename Theme Folder")
    folders=$(find "$WALLPAPER_BASE" -mindepth 1 -maxdepth 1 -type d | sed "s|$WALLPAPER_BASE/||")
    old_folder=$(printf "%s\n" "$folders" | fzf --prompt="✏️ Rename which theme? ")
    is_protected_theme "$old_folder" && echo "❌ Cannot rename protected theme." && exit 1
    read -rp "📁 New name: " new_folder
    mv "$WALLPAPER_BASE/$old_folder" "$WALLPAPER_BASE/$new_folder"
    echo "✅ Renamed to $new_folder"
    exit 0
    ;;

  "🖼️ Rename/Delete Wallpaper")
    folders=$(find "$WALLPAPER_BASE" -mindepth 1 -maxdepth 1 -type d | sed "s|$WALLPAPER_BASE/||")
    theme_folder=$(printf "%s\n" "$folders" | fzf --prompt="🎨 Select theme: ")
    is_protected_theme "$theme_folder" && echo "❌ Cannot edit wallpapers of protected theme." && exit 1

    wp_folder="$WALLPAPER_BASE/$theme_folder"
    wallpapers=($(find "$wp_folder" -maxdepth 1 -type f ! -name current.png))
    selected_wp=$(printf "%s\n" "${wallpapers[@]}" | fzf --prompt="🖼️ Choose wallpaper: " --preview="kitty +kitten icat {}")
    [[ -z "$selected_wp" ]] && exit 0

    action=$(printf "🗑️ Delete\n✏️ Rename" | fzf --prompt="🔧 Action: ")
    case "$action" in
      "🗑️ Delete")
        rm "$selected_wp" && echo "✅ Deleted: $(basename "$selected_wp")"
        ;;
      "✏️ Rename")
        read -rp "📛 New filename (with extension): " new_name
        mv "$selected_wp" "$wp_folder/$new_name"
        echo "✅ Renamed to: $new_name"
        ;;
    esac
    exit 0
    ;;

  *)
    echo "❌ Cancelled."
    exit 0
    ;;
esac

# Wallpaper Download Section
# 🖌 Theme Selection
chosen_theme=$(printf "dark\nlight\ncustom" | fzf --prompt="🎨 Theme: " --header="Choose a theme" --border --layout=reverse --height=40%)
[[ -z "$chosen_theme" ]] && echo "❌ No theme selected." && exit 1
if [[ "$chosen_theme" == "custom" ]]; then
  read -rp "🎨 Enter custom theme name: " custom_theme
  [[ -z "$custom_theme" ]] && exit 1
  chosen_theme="$custom_theme"
fi

# 📥 User Inputs
repo=$( (get_history; echo) | fzf --prompt="🔗 GitHub repo (e.g., username/repo): " --height=40% --layout=reverse)
[[ -z "$repo" ]] && echo "❌ Repo required." && exit 1
save_history "$repo"

folder_name=$( (get_history; echo) | fzf --prompt="📁 Folder name: " --height=40% --layout=reverse)
[[ -z "$folder_name" ]] && exit 1
save_history "$folder_name"

read -rp "🔢 How many wallpapers to list (default: 10): " num_limit
num_limit=${num_limit:-10}

preview_fzf=$(printf "no\nyes" | fzf --prompt="🖼️ Show image preview in selector? (default: no): " --layout=reverse --height=20%)
show_preview=${preview_fzf,,}

# 📁 Setup Directories
out_dir="$WALLPAPER_BASE/${chosen_theme}-${folder_name}"
mkdir -p "$out_dir"
preview_dir=$(mktemp -d)

# 🌐 Fetch image list
echo "📡 Fetching image list from https://github.com/$repo ..."
mapfile -t image_paths < <(
  curl -s "https://api.github.com/repos/${repo}/git/trees/HEAD?recursive=1" |
    jq -r '.tree[].path' |
    grep -iE '\\.(png|jpe?g|webp)$' |
    head -n "$num_limit"
)
[[ ${#image_paths[@]} -eq 0 ]] && echo "❌ No images found." && exit 1

# 🖼️ Preview download logic
if [[ "$show_preview" == "yes" ]]; then
  echo "📥 Downloading previews..."
  for img in "${image_paths[@]}"; do
    curl -sL "https://raw.githubusercontent.com/$repo/HEAD/$img" -o "$preview_dir/$(basename "$img")" &
  done
  wait
  preview_cmd='f="'$preview_dir'/$(basename {})"; [[ -f "$f" ]] && kitty +kitten icat "$f" || echo "❌ No preview."'
else
  preview_cmd="echo {}"
fi

# 📦 Ask Download Mode
choice=$(printf "📥 Download all\n🎯 Pick manually" | fzf --prompt="🧩 Mode: " --height=30% --border --layout=reverse)
[[ -z "$choice" ]] && echo "❌ No option selected." && exit 1

# 📥 Download All
if [[ "$choice" == "📥 Download all" ]]; then
  echo "⬇️ Downloading all wallpapers..."
  for path in "${image_paths[@]}"; do
    filename="$(basename "$path")"
    url="https://raw.githubusercontent.com/$repo/HEAD/$path"
    echo "⬇️ $filename"
    curl -sL "$url" -o "$out_dir/$filename" || echo "❌ Failed: $url"
  done

# 🎯 Manual Select & Immediate Download
else
  remaining=(${image_paths[@]})
  while true; do
    display_list=( )
    for img in "${remaining[@]}"; do
      display_list+=("$(basename "$img")")
    done
    selected_display=$(printf "%s\n" "${display_list[@]}" | fzf \
      --prompt="📷 Select wallpaper (ESC to finish): " \
      --preview="$preview_cmd" \
      --preview-window=right:60% \
      --layout=reverse --border --height=90%)
    [[ -z "$selected_display" ]] && break

    selected_path=""
    for img in "${remaining[@]}"; do
      if [[ "$(basename "$img")" == "$selected_display" ]]; then
        selected_path="$img"
        break
      fi
    done

    filename="$selected_display"
    url="https://raw.githubusercontent.com/$repo/HEAD/$selected_path"
    echo "⬇️ Downloading: $filename"
    curl -sL "$url" -o "$out_dir/$filename" || echo "❌ Failed to download: $url"

    # Remove selected from remaining
    temp=( )
    for item in "${remaining[@]}"; do
      [[ "$item" != "$selected_path" ]] && temp+=("$item")
    done
    remaining=("${temp[@]}")
  done
fi

# 🎯 Set current.png
mapfile -t downloaded < <(find "$out_dir" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.webp" \))
if [[ ${#downloaded[@]} -gt 0 ]]; then
  random="${downloaded[RANDOM % ${#downloaded[@]}]}"
  cp "$random" "$out_dir/current.png"
  echo "✅ Set current.png to: $(basename "$random")"
else
  echo "⚠️ No wallpapers downloaded, current.png not created."
fi

rm -rf "$preview_dir"
echo "✅ Done."

