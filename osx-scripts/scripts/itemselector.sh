#!/bin/sh

kitty=/Applications/kitty.app/Contents/MacOS/kitty
$kitty --title itemselector --single-instance --instance-group=itemselector -o hide_window_decorations=titlebar-only -o macos_quit_when_last_window_closed=yes -o font_size=16 $@
