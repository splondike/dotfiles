#!/bin/bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

packages=(fish git kitty nvim nvim-local zellij makenote w3m skhd karabiner aerospace)
do_stow "${packages[@]}"
