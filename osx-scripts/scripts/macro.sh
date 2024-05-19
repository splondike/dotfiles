#!/bin/sh

# In yabai
# yabai -m window --focus west
# cliclick t:q kd:ctrl t:w ku:ctrl kd:ctrl t:l ku:ctrl kp:arrow-up kp:return
# cliclick t:q kd:ctrl t:w ku:ctrl kp:arrow-up kp:return
# yabai -m window --focus east

# In Zellij
# cliclick kd:alt kp:arrow-right ku:alt
# cliclick kd:ctrl t:l ku:ctrl kp:arrow-up kp:return
# cliclick kd:alt kp:arrow-left ku:alt

# Pure kitty
# See GNU showkey -a for keycodes. Just use a Linux VM to check things

# Ctrl-c (03) Ctrl-l (0c) up (1b 5b 41) enter (0d)
# printf '\x03\x0c\x1b\x5b\x41\x0d' | kitty-send-text
# Ctrl-l up enter
printf '\x0c\x1b\x5b\x41\x0d' | kitty-send-text

# Mermaid
# pbcopy < ~/blah.erd
# yabai -m window --focus west
# cliclick kd:cmd t:a t:v ku:cmd
# yabai -m window --focus east
