# =============================================================================
# ZSH Configuration - Developer Setup
# =============================================================================

# HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

# DIRECTORY
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT
setopt CDABLE_VARS

# COMPLETION
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# KEY BINDINGS
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# ENVIRONMENT
export EDITOR='vim'
export VISUAL='vim'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export CLICOLOR=1
export BAT_THEME="base16"

# PATH
export JAVA_HOME=/opt/homebrew/opt/openjdk
export PATH="$JAVA_HOME/bin:$PATH"
export PATH="$HOME/Dev/tools/build/darwin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

# ALIASES - Modern replacements
alias ls='eza --icons=auto'
alias ll='eza -la --icons=auto --git'
alias la='eza -a --icons=auto'
alias lt='eza --tree --level=2 --icons=auto'
alias cat='bat --style=plain'
alias catn='bat'

# ALIASES - Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# ALIASES - Git
alias g='git'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gc='git commit'
alias gca='git commit -a'
alias gcm='git commit -m'
alias gco='git checkout'
alias gb='git branch'
alias gba='git branch -a'
alias gp='git push'
alias gpl='git pull'
alias gl='git log --oneline -20'
alias glog='git log --graph --oneline --decorate'
alias gst='git stash'
alias gstp='git stash pop'

# ALIASES - Utilities
alias c='clear'
alias h='history'
alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -h'
alias reload='source ~/.zshrc'
alias path='echo -e ${PATH//:/\\n}'

# FUNCTIONS
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.tar.xz)  tar xJf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# GOOGLE CLOUD SDK (via Homebrew)
[[ -f "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc" ]] && source "$(brew --prefix)/share/google-cloud-sdk/path.zsh.inc"
[[ -f "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc" ]] && source "$(brew --prefix)/share/google-cloud-sdk/completion.zsh.inc"

# STARSHIP PROMPT
eval "$(starship init zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Added by LM Studio CLI (lms)
export PATH="$PATH:$HOME/.lmstudio/bin"
# End of LM Studio CLI section

# Alias for claude --dangerously-skip-permissions
claude-bah() { claude --dangerously-skip-permissions "$@"; }

alias vault="cd '$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/zackbart'"

# ZOXIDE (smarter cd) — must be last
export _ZO_DOCTOR=0
eval "$(zoxide init --cmd cd zsh)"

