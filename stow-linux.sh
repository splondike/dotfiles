#!/bin/bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

packages=(fish aerc git kitty nvim nvim-local rofi sway waybar zellij makenote notmuch w3m vdirsyncer khal khard shotwell)
do_stow "${packages[@]}"