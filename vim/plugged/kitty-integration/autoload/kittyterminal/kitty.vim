function! kittyterminal#kitty#Send() abort
    " Complements the listen_on and kitty_mod+; config in kitty.conf
    " Something like:
    " #!/bin/sh
    "
    " TARGET_PATH=$HOME/.cache/kitty-target-window
    "
    " if [ ! -e "$TARGET_PATH" ];then
    "     exit 0
    " fi
    "
    " pid=$(grep -o '^[0-9]\+' "$TARGET_PATH")
    " window_id=$(grep -o '[0-9]\+$' "$TARGET_PATH")
    " sock=$HOME/.cache/kitty-$pid.sock
    " if [ ! -e "$sock" ];then
    "     exit 0
    " fi
    "
    " kitty @ --to unix:$sock send-text --match "id:$window_id" --stdin

    execute(".w !kitty-send-text")
endfunction
