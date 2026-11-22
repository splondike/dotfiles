#!/bin/sh

# Ctrl-c
printf '\x03' | ~/.config/kitty/scripts/kitty-send-text $@
sleep 0.5
# Ctrl-l, go up, enter
printf '\x0c\x1b\x5b\x41\x0d' | ~/.config/kitty/scripts/kitty-send-text $@

# In Zellij
# cliclick kd:alt kp:arrow-right ku:alt
# cliclick kd:ctrl t:l ku:ctrl kp:arrow-up kp:return
# cliclick kd:alt kp:arrow-left ku:alt

# # Mermaid
# pbcopy < ~/blah.mermaid
# aerospace focus left
# cliclick kd:cmd t:a t:v ku:cmd
# aerospace focus right
