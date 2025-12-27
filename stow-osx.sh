#!/bin/bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

packages=(fish git tig kitty nvim nvim-local zellij makenote w3m skhd aerospace nushell visidata k9s ripgrep)
do_stow "${packages[@]}"
