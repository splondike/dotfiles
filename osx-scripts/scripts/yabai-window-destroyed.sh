#!/bin/sh

# Executed when a findow is destroyed. Its job is to find an appropriate window to
# change the focus to if nothing is currently focussed.

if yabai -m query --windows --space | jq -er 'map(select(."is-floating" == false)) | map(select(."has-focus" == true)) | length == 0' >/dev/null; then
    # Is-floating to not pick up teams windows
    id=`yabai -m query --windows --space | jq -r 'map(select(."is-floating" == false and .frame.h != 0)) | .[0].id'`
    [ $id != null ] && yabai -m window --focus $id
fi
