#!/bin/sh

macro_mode_file="$HOME/.cache/osx-macro-mode"
if [ -e "$macro_mode_file" ];then
    option=$(cat "$macro_mode_file")
else
    option=default
fi

if [ "$option" = "default" ];then
    # Ctrl-l up enter
    printf '\x0c\x1b\x5b\x41\x0d' | kitty-send-text
elif [ "$option" = "swapwin" ];then
    # Swap to last focussed window
    aerospace focus-back-and-forth
else
    echo "Unknown option: $option"
fi

# In Zellij
# cliclick kd:alt kp:arrow-right ku:alt
# cliclick kd:ctrl t:l ku:ctrl kp:arrow-up kp:return
# cliclick kd:alt kp:arrow-left ku:alt

# # Mermaid
# pbcopy < ~/blah.mermaid
# aerospace focus left
# cliclick kd:cmd t:a t:v ku:cmd
# aerospace focus right
