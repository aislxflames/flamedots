#!/bin/bash

# Define common commit messages
messages+=(
  "✨ Initial setup of Hyprland config"
  "🔥 Optimize performance and fix bugs"
  "📝 Update docs and improve README"
  "🎨 Refactor config styling"
  "🔧 Tweak keybindings and layout"
  "🚀 Enhance workflow performance"
  "🔒 Improve security configurations"
  "🎶 Add audio controls for Hyprland"
  "🌈 Update color schemes and themes"
  "🧹 Clean up deprecated config options"
  "⚡ Speed up startup process"
  "🛠️ Fix broken symlinks and paths"
  "🎉 Add support for new Hyprland features"
  "🔄 Sync dotfiles with upstream"
  "📦 Update dependencies and packages"
  "💅 Polish the UI for better UX"
  "🖥️ Add support for multi-monitor setups"
  "🔧 Bugfix: Correct window behavior"
  "💡 Enhance configuration usability"
  "💬 Add comments for clarity"
  "⚙️ Adjust system settings for stability"
  "🛠️ Fix minor issues with layout"
  "💻 Add more custom scripts for Hyprland"
  "🎯 Precision tweaks for screen scaling"
  "🌟 Update to latest Hyprland version"
  "🚧 Temporary commit for ongoing work"
  "💥 Major update for performance overhaul"
  "🪛 Custom Message"
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
git push origin flamedotsv2

