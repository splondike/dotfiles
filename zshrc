export EDITOR='/usr/bin/nvim'
export GIT_EDITOR='/usr/bin/nvim'
export GOPATH="$HOME/.cache/go"

alias vim='nvim'
alias gg='git status'
alias kssh='kitty +kitten ssh'
alias pvim='poetry run nvim'

# Don't use vi style keybinds for now
bindkey -e
# Prompt
PS1='%F{green}%* %~%f%(?..%F{red} (%?%)%f)$ '
