#!/bin/bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

# A couple of my packages would try to own these dirs unless I make it for
# them
mkdir -p ~/bin
mkdir -p ~/.local
mkdir -p ~/.config

packages=(fish git nvim nvim-local zellij makenote termux s6-termux ripgrep)
do_stow "${packages[@]}"
