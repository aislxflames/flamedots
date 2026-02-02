#!/bin/bash

HISTORY_FILE="$HOME/.tmux_paths"

# Show existing sessions with fzf if no arguments or "show"
if [ $# -eq 0 ] || [ "$1" = "show" ]; then
    # Combine sessions and history paths
    selection=$({
        tmux list-sessions -F "#{session_name}" 2>/dev/null | sed 's/^/[session] /'
        [ -f "$HISTORY_FILE" ] && cat "$HISTORY_FILE" | sed 's/^/[path] /'
    } | fzf --prompt="Select session or path: ")
    
    if [[ "$selection" == "[session] "* ]]; then
        session="${selection#\[session\] }"
        tmux attach-session -t "$session"
    elif [[ "$selection" == "[path] "* ]]; then
        path="${selection#\[path\] }"
        exec "$0" "$path"
    fi
    exit 0
fi

# Determine target directory
target_dir="$1"

# Expand ~ to home directory and resolve full path
target_dir="${target_dir/#\~/$HOME}"
target_dir=$(realpath "$target_dir")

# Check if directory exists
if [ ! -d "$target_dir" ]; then
    echo "Directory does not exist: $target_dir"
    exit 1
fi

# Save path to history
mkdir -p "$(dirname "$HISTORY_FILE")"
grep -v "^$target_dir$" "$HISTORY_FILE" 2>/dev/null > "${HISTORY_FILE}.tmp" || true
echo "$target_dir" >> "${HISTORY_FILE}.tmp"
tail -20 "${HISTORY_FILE}.tmp" > "$HISTORY_FILE"
rm -f "${HISTORY_FILE}.tmp"

# Create session name from directory path
session_name=$(basename "$target_dir")

echo "Creating/attaching to session: $session_name"

# Check if session already exists
if tmux has-session -t "$session_name" 2>/dev/null; then
    tmux attach-session -t "$session_name"
else
    tmux new-session -d -s "$session_name" -c "$target_dir"
    tmux attach-session -t "$session_name"
fi
