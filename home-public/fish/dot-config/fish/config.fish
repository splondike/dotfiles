if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x EDITOR 'nvim'
    set -x GIT_EDITOR 'nvim'
    set -x RIPGREP_CONFIG_PATH "$HOME/.config/ripgreprc"
    set GOPATH "$HOME/.cache/go"
    set -U fish_greeting
    bind ctrl-o edit_command_buffer
    bind ctrl-n backward-word
    bind ctrl-i forward-word
    bind ctrl-p 'cd (fd -t d | fzf);commandline -f repaint'
    bind 'escape,.' history-token-search-backward
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
            fish_add_path -a /opt/homebrew/bin
            fish_add_path -a ~/software/small-utilities
            pyenv init - | source
            set -x SSH_AUTH_SOCK "$HOME/.local/state/ssh-agent.sock"
            set -x XDG_CONFIG_HOME "$HOME/.config"
            set -x DOTNET_ROOT "/usr/local/share/dotnet"
        case Linux
            fish_add_path -a ~/Programming/small-utilities
            fish_add_path -a $GOPATH/bin
            set -x SSH_AUTH_SOCK "/var/run/user/1000/ssh-agent.sock"
    end
end
