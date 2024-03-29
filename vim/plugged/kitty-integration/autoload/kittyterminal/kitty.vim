function! kittyterminal#kitty#Send() abort
    " Complements the listen_on and kitty_mod+; config in kitty.conf
    " Something like:
    " #!/bin/sh
    " TARGET_PATH=$HOME/.cache/kitty-target-window
    "
    " if [ ! -e "$TARGET_PATH" ];then
    "     exit 0
    " fi
    "
    " sock=$(head -n 1 "$TARGET_PATH")
    " window_id=$(tail -n 1 "$TARGET_PATH")
    "
    " kitty @ --to "$sock" send-text --match "id:$window_id" --stdin

    execute(".w !kitty-send-text")
endfunction
