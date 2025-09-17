# ================================================
# ZSH CONFIG: Oh My Zsh + Autosuggestions
# ================================================

# -------------------------------
# Start ssh-agent if not already running
# -------------------------------
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
fi

# -------------------------------
# Persistent command history
# -------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# History options
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE                                                                                                                                  setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_FIND_NO_DUPS

# -------------------------------
# Oh My Zsh setup
# -------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Choose a theme (default Zsh theme)
ZSH_THEME="robbyrussell"

# Enable plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Load Oh My Zsh
if [ -d "$ZSH" ]; then
    source $ZSH/oh-my-zsh.sh
fi

# -------------------------------
# zsh-autosuggestions
# -------------------------------
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# -------------------------------
# zsh-syntax-highlighting
# -------------------------------
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# -------------------------------
# Custom prompt fallback
# -------------------------------
set_prompt() {
    if [[ "$PWD" == "$HOME" ]]; then
        PROMPT='%F{cyan}~%f %# '
    else
        PROMPT='%F{cyan}%~%f %# '
    fi
}

autoload -Uz add-zsh-hook
add-zsh-hook chpwd set_prompt
add-zsh-hook precmd set_prompt
set_prompt

# -------------------------------
# Aliases & Extras
# -------------------------------
alias ll='exa -lah --git'        # Use exa instead of ls
alias gs='git status'
alias gp='git push'
alias gd='git diff'
alias ls='eza -lh --color=auto --sort=modified'

# -------------------------------
export TERM=xterm-256color

#--------------------------------
# Keybindings
#--------------------------------
# Move to the start of the line
bindkey '^A' beginning-of-line

# Move to the end of the line
bindkey '^E' end-of-line
# Force Enter (Ctrl+M) to execute commands
bindkey '^M' accept-line #important

# Initialize fasd
eval "$(fasd --init auto)"

# Search and Load folder sl
sl() {
  dir=$(find $HOME -type d -iname "$1" 2>/dev/null | head -n 1)
  if [ -n "$dir" ]; then
    cd "$dir" || return
    echo "→ Moved to: $dir"
  else
    echo "No match found for: $1"
  fi
}
