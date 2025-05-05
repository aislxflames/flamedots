#!/bin/bash

# Define common commit messages
messages=(
  "Initial commit"
  "Update configuration"
  "Fix bugs"
  "Add new features"
  "Improve performance"
  "Update documentation"
  "Refactor code"
  "Style: format or lint"
  "Cleanup unused files"
  "Update dependencies"
  "Custom message"
)

# Git add
git add .

# Choose a message
selected=$(printf "%s\n" "${messages[@]}" | fzf --prompt="Select commit message: ")

# If custom, ask for input
if [[ "$selected" == "Custom message" ]]; then
  read -rp "Enter your custom commit message: " custom_msg
  commit_msg="$custom_msg"
else
  commit_msg="$selected"
fi

# Commit
git commit -m "$commit_msg"

# Push to main
git push

