#!/bin/bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

packages=(fish git kitty nvim zellij makenote w3m)
do_stow "${packages[@]}"
