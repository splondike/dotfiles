if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x EDITOR 'nvim'
    set -x GIT_EDITOR 'nvim'
    set GOPATH "$HOME/.cache/go"
    set -U fish_greeting
    fish_add_path -a ~/bin
    fish_add_path -a ~/bin/mine
    fish_add_path -a ~/go/bin/
    fish_add_path -a ~/.local/bin
    alias vim='nvim'
    alias gg='git status'
    alias dc='docker-compose'
    alias kssh='kitty +kitten ssh'
    alias pvim='poetry run nvim'
    set uname $(uname)
    switch $uname
        case Darwin
            fish_add_path -a ~/software/small-utilities
            pyenv init - | source
            set -U GIT_EDITOR "$HOME/bin/git_commit_editor"
            set -x SSH_AUTH_SOCK "$HOME/.local/state/ssh-agent.sock"
        case Linux
            fish_add_path -a ~/Programming/small-utilities
            fish_add_path -a $GOPATH/bin
            set -x SSH_AUTH_SOCK "/var/run/user/1000/ssh-agent.sock"
    end
end
