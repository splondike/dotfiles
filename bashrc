# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

export EDITOR='/usr/bin/nvim'
export GIT_EDITOR='/usr/bin/nvim'
export GOPATH="$HOME/.cache/go"

PS1='\[\033[00;32m\]\t \W> \['$(tput sgr0)'\]'
export PATH=~/bin/preempt:$PATH
export PATH=$PATH:/opt/android-sdk-linux/platform-tools/:/opt/android-sdk-linux/tools/
export PATH=$PATH:/opt/android-ndk-r15b/
export PATH="$PATH:$HOME/.rvm/bin"
export PATH=$PATH:~/bin/mine
export PATH=$PATH:~/Programming/small-utilities
export PATH="$PATH:$GOPATH/bin"
export ANDROID_HOME=/opt/android/
export ANDROID_NDK=/opt/android-ndk-r15b/

alias vim='nvim'
alias gg='git status'
alias kssh='kitty +kitten ssh'
alias pvim='poetry run nvim'

export VAGRANT_DEFAULT_PROVIDER=virtualbox
source $HOME/.rvm/scripts/rvm

export FZF_ALT_C_COMMAND="fd -H --type directory"
export FZF_CTRL_T_COMMAND="fd"
export FZF_DEFAULT_COMMAND="fd --type f"

# timetrap autocomplete https://github.com/samg/timetrap
source ~/.rvm/gems/ruby-2.7.2/gems/timetrap-1.15.2/completions/bash/timetrap-autocomplete.bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
