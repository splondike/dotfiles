#!/usr/bin/env bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

# A couple of my packages would try to own these dirs unless I make it for
# them
mkdir -p ~/bin
mkdir -p ~/.local
mkdir -p ~/.config

packages=(fish aerc git tig kitty nvim nvim-local rofi sway swaylock waybar zellij makenote mbsync notmuch w3m vdirsyncer khal khard shotwell nushell visidata ripgrep bin-shared bin-private ssh nvim-private launchers)
do_stow "${packages[@]}"
