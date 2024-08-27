#!/bin/bash

cd $(dirname $(readlink -f $0))
. ./stow-home-general.sh

packages=(fish git nvim zellij makenote termux)
do_stow "${packages[@]}"
