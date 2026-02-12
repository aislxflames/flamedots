#!/bin/bash

z() {
    if [[ $# -eq 0 ]]; then
        # Show fzf menu with recent paths
        local selected_path
        selected_path=$(zoxide query -l | fzf --height=40% --layout=reverse --border --prompt="Jump to: ")
        if [[ -n "$selected_path" ]]; then
            cd "$selected_path" || return 1
        fi
    else
        # Use zoxide to jump to path and add it to database
        local result
        result=$(zoxide query "$@" 2>/dev/null)
        if [[ -n "$result" ]]; then
            cd "$result" || return 1
        else
            # If path doesn't exist in zoxide, try direct cd and add to zoxide
            if cd "$@" 2>/dev/null; then
                zoxide add "$(pwd)"
            else
                echo "z: no match found for '$*'"
                return 1
            fi
        fi
    fi
}

# Disable tab completion for z
if [[ -n "$ZSH_VERSION" ]]; then
    autoload -U compinit
    compinit
    compdef -d z
fi
