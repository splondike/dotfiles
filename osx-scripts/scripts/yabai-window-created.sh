#!/bin/sh

# Executed when a new OS window is created. Since I swapped to single instance kitty
# the default Yabai behaviour doesn't focus the new terminal when I spawn it if the
# currently focussed application isn't Kitty itself. This script ensures it does
# get focus.
if [ $(yabai -m query --windows --space | jq -er "map(select(.id == $YABAI_WINDOW_ID)) | .[0].app") = "kitty" ];then
    yabai -m window --focus $YABAI_WINDOW_ID
fi

