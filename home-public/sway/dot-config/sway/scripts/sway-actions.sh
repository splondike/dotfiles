#!/bin/sh

actions="blank\npoweroff\nreboot"
rtn=$(echo -e $actions | rofi -i -dmenu)

case $rtn in
blank)
    sleep 1
    kill -s USR1 `pgrep swayidle`
    ;;
poweroff)
    systemctl poweroff
    ;;
reboot)
    systemctl reboot
    ;;
esac
