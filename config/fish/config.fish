if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x EDITOR 'nvim'
    set -x GIT_EDITOR 'nvim'
    set GOPATH "$HOME/.cache/go"
    set -x SSH_AUTH_SOCK "/var/run/user/1000/ssh-agent.sock"
    fish_add_path -a ~/bin
    fish_add_path -a ~/bin/mine
    alias vim='nvim'
    alias gg='git status'
    alias dc='docker-compose'
    alias kssh='kitty +kitten ssh'
    alias pvim='poetry run nvim'
    set uname $(uname)
    switch $uname
        case Darwin
            fish_add_path -a ~/software/small-utilities
            set -U GIT_EDITOR "$HOME/bin/git_commit_editor"
        case Linux
            fish_add_path -a ~/Programming/small-utilities
            fish_add_path -a $GOPATH/bin
    end
end
