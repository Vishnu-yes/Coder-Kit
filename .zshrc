# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ======================================================
# 🌙 Chad LunarVim Style ZSHRC (Termux Edition)
# ======================================================

# -------------------------------
# Paths & Environment
# -------------------------------
export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
export VIMRUNTIME="/data/data/com.termux/files/usr/share/nvim/runtime"
export LV_CONFIG_DIR="$HOME/.config/lvim-test"

# -------------------------------
# Theme Color Support.
# -------------------------------
export TERM="xterm-256color"
export COLORTERM="truecolor"

# -------------------------------
# SSH Agent Auto-Start
# -------------------------------
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" >/dev/null
    ssh-add ~/.ssh/id_ed25519 >/dev/null 2>&1
fi

# -------------------------------
# History: Infinite, Shared, Clean
# -------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_FIND_NO_DUPS

# -------------------------------
# Oh My Zsh
# -------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins: Git + productivity
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  fasd
)

# Load Oh My Zsh
[ -f "$ZSH/oh-my-zsh.sh" ] && source "$ZSH/oh-my-zsh.sh"

# -------------------------------
# zsh-autosuggestions & syntax-highlighting
# (if installed outside Oh My Zsh plugins)
# -------------------------------
[[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && \
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && \
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# -------------------------------
# Fast Directory Navigation (fasd)
# -------------------------------
eval "$(fasd --init auto)"

# -------------------------------
# Aliases: Extra Speed
# -------------------------------
alias ll='exa -lah --git'
alias gs='git status'
alias gp='git push'
alias gd='git diff'
alias ls='exa -lh --color=auto --sort=modified'
alias cl='clear'
alias vi='nvim'

# -------------------------------
# Keybindings: Vim-style Power
# -------------------------------
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^M' accept-line  # Ctrl+M = Enter

# -------------------------------
# Super Directory Finder
# -------------------------------
sl() {
    local dir
    dir=$(find "$HOME" -type d -iname "$1" 2>/dev/null | head -n 1)
    if [[ -n "$dir" ]]; then
        cd "$dir" || return
        echo "→ Moved to: $dir"
    else
        echo "❌ No match found for: $1"
    fi
}

# -------------------------------
# Extra Visual & Performance Tweaks
# -------------------------------
setopt AUTO_MENU
setopt AUTO_PARAM_SLASH
setopt NO_BEEP
setopt HIST_IGNORE_ALL_DUPS

# Better grep
export GREP_OPTIONS='--color=auto'

echo "🚀 Chad ZSH Loaded! LunarVim Mode: ACTIVATED"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
