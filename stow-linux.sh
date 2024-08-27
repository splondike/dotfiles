#!/bin/bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

packages=(fish aerc git kitty nvim rofi sway waybar zellij makenote notmuch)
do_stow "${packages[@]}"
