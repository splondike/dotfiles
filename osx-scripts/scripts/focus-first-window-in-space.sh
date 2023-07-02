#!/bin/sh

if yabai -m query --windows --space | jq -er 'map(select(."is-floating" == false)) | map(select(."has-focus" == true)) | length == 0' >/dev/null; then
    # Is-floating to not pick up teams windows
    id=`yabai -m query --windows --space | jq -r 'map(select(."is-floating" == false and .frame.h != 0)) | .[0].id'`
    [ $id != null ] && yabai -m window --focus $id
fi
