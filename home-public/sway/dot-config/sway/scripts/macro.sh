#!/bin/sh

# Ctrl-l, go up, enter
printf '\x0c\x1b\x5b\x41\x0d' | ~/.config/kitty/scripts/kitty-send-text $@
