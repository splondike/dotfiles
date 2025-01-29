#!/bin/bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

packages=(fish aerc git tig kitty nvim nvim-local rofi sway swaylock waybar zellij makenote notmuch w3m vdirsyncer khal khard shotwell nushell)
do_stow "${packages[@]}"
