if status is-interactive
    # Commands to run in interactive sessions can go here
    set EDITOR '/usr/bin/nvim'
    set GIT_EDITOR '/usr/bin/nvim'
    set GOPATH "$HOME/.cache/go"
    fish_add_path -a ~/bin/mine
    fish_add_path -a ~/Programming/small-utilities
    fish_add_path -a $GOPATH/bin
    alias vim='nvim'
    alias gg='git status'
    alias kssh='kitty +kitten ssh'
    alias pvim='poetry run nvim'
end
