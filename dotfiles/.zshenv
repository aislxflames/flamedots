# --------------------------
# Auto-install dependencies if missing
# --------------------------
dependencies=(exa fzf zoxide git)
# source= ~/.flmrc

# Detect package manager
if command -v pacman >/dev/null 2>&1; then
    PKG_INSTALL="sudo pacman -S --noconfirm"
elif command -v apt >/dev/null 2>&1; then
    PKG_INSTALL="sudo apt install -y"
elif command -v dnf >/dev/null 2>&1; then
    PKG_INSTALL="sudo dnf install -y"
else
    PKG_INSTALL=""
fi

for dep in "${dependencies[@]}"; do
    if ! command -v $dep >/dev/null 2>&1; then
        echo "$dep not found, installing..."
        $PKG_INSTALL $dep
    fi
done

# --------------------------
# zoxide
# --------------------------
eval "$(zoxide init zsh)"

# --------------------------
# PATH and environment
# --------------------------
export PATH=$HOME/.local/bin:$HOME/.npm-global/bin:$PATH
export TERM=kitty
export QT_QPA_PLATFORMTHEME=gtk3
export TERM="xterm-256color"

# --------------------------
# Aliases
# --------------------------
alias ii='yay -S --noconfirm'
alias i='yay'
alias t='tmux-session'
# . "$HOME/.cargo/env"

# --------------------------
# Better ls with exa
# --------------------------
alias ls='exa --icons --color=auto'
alias ll='exa -lh --icons --color=auto'
alias la='exa -lha --icons --color=auto'
alias llt='exa -lh --tree --level=2'

# --------------------------
# Interactive cd with fzf
# --------------------------
fcd() {
    local dir
    dir=$(find . -type d 2>/dev/null | fzf +m) && cd "$dir"
}
alias cdf='fcd'

# --------------------------
# Zsh completion
# --------------------------
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt '%SScrolling active: %p%s'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# --------------------------
# Optional: install fzf-tab for better tab completions
# --------------------------
if [ ! -d "$HOME/.fzf-tab" ]; then
    git clone https://github.com/Aloxaf/fzf-tab ~/.fzf-tab
fi
source ~/.fzf-tab/fzf-tab.plugin.zsh

