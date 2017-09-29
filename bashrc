# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

export EDITOR='/usr/bin/vim'

PS1='\['$(tput setf 10)'\]\t \W> \['$(tput sgr0)'\]'
export PATH=~/bin/preempt:$PATH
export PATH=$PATH:~/bin/mine
export PATH=$PATH:/opt/android-sdk-linux/platform-tools/:/opt/android-sdk-linux/tools/
export PATH=$PATH:/opt/android-ndk-r15b/
export ANDROID_HOME=/opt/android/
export ANDROID_NDK=/opt/android-ndk-r15b/

alias ghc='stack ghc --'
alias ghci='stack ghci --'

export VAGRANT_DEFAULT_PROVIDER=virtualbox
