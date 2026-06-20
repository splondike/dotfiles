#!/bin/sh

shopt -s nullglob globstar

prefix=${PASSWORD_STORE_DIR-~/.password-store/}
password_files=$(cd $prefix ; find . -type f | grep '/web-' | sed -e 's/^\.\///g' -e "s/\.gpg$//g")
gui_menu="rofi -dmenu -i"

item=$(printf '%s\n' "${password_files[@]}" | $gui_menu "$@")

[[ -n $item ]] || exit

content=$(pass show "$item")

username=$(echo -n "$content" | sed -n 's/^username: //p')
url=$(echo -n "$content" | sed -n 's/^url: //p')
totp=$(echo -n "$content" | sed -n 's/^totp: //p')
password=$(echo -n "$content" | head -n 1)
menu_items=()
if [[ -n "$username" && -n "$password" ]];then
    menu_items+=( "type credentials" )
fi
if [[ -n "$username" ]];then
    menu_items+=( "username" )
fi
if [[ -n "$password" ]];then
    menu_items+=( "password" )
fi
if [[ -n "$url" ]];then
    menu_items+=( "website" )
fi
if [[ -n "$totp" ]];then
    menu_items+=( "totp" )
fi

action=$(printf '%s\n' "${menu_items[@]}" | $gui_menu "$@")

copy() {
    if [ -n $WAYLAND_DISPLAY ];then
        echo -n "$1" | wl-copy
    else
        echo -n "$1" | xclip
        echo -n "$1" | xclip -selection clipboard
    fi
}

case "$action" in
    "type credentials")
        if [ -n $WAYLAND_DISPLAY ];then
            wtype "$username"
            sleep 0.5
            wtype -k tab
            sleep 0.5
            wtype "$password"
            sleep 0.5
            wtype -k return
        else
            echo -n "$username" | xdotool type --clearmodifiers --file -
            echo -en "\t" | xdotool type --clearmodifiers --file -
            echo -n "$content" | head -n 1 | xdotool type --clearmodifiers --file -
            xdotool key Return
        fi
        ;;
    "username")
        copy "$username"
        ;;
    "password")
        copy "$password"
        ;;
    "website")
        copy "$url"
        ;;
    "totp")
        code=$(oathtool --base32 --totp "$totp")
        copy "$code"
        ;;
esac

