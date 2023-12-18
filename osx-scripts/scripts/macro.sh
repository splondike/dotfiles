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
# See showkey -a for keycodes
printf '\x0c\x1b\x5b\x41\x0d' | kitty-send-text
