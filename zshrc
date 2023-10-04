export EDITOR='/usr/bin/nvim'
export GIT_EDITOR='/usr/bin/nvim'
export GOPATH="$HOME/.cache/go"

alias vim='nvim'
alias gg='git status'
alias kssh='kitty +kitten ssh'
alias pvim='poetry run nvim'

# -- Stable settings --
# {{{

export HISTFILE="~/.cache/zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# Don't use vi style keybinds for now. But see https://thevaluable.dev/zsh-install-configure-mouseless/
bindkey -e

# Prompt
PS1='%F{green}%* %~%f%(?..%F{red} (%?%)%f)$ '
# }}}

# -- Autocomplete --
# {{{
zstyle ':completion:*:*:git:*' script ~/.config/zsh/git-completion.bash
fpath=(~/.config/zsh $fpath)
autoload -Uz compinit && compinit
_comp_options+=(globdots)
# }}}
