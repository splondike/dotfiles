#!/bin/sh

# Arbitrary id
notification_id=10214

if [ "$1" = "toggle-mute" ];then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
else
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ "$1"
fi

notify-send --expire-time 1000 --replace-id=$notification_id "$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"
