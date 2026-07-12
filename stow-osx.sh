#!/bin/bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

# A couple of my packages would try to own these dirs unless I make it for
# them
mkdir -p ~/bin
mkdir -p ~/.local
mkdir -p ~/.config

packages=(fish git tig kitty nvim nvim-local zellij makenote w3m skhd aerospace nushell visidata k9s ripgrep bin-shared)
do_stow "${packages[@]}"
