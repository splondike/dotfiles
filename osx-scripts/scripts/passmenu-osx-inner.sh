#!/usr/bin/env bash

fzf=/opt/homebrew/bin/fzf
SUBDIR=internet/
prefix=${PASSWORD_STORE_DIR-~/.password-store/$SUBDIR}
password_files=( $(cd $prefix ; find . -name "*.gpg") )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

item=$(printf '%s\n' "${password_files[@]}" | $fzf )

[[ -n $item ]] || exit

content=$(pass show "$SUBDIR$item")

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

action=$(printf '%s\n' "${menu_items[@]}" | fzf)

[[ -n "$action" ]] || exit

copy() {
    echo -n "$1" | pbcopy
}

case "$action" in
    "type credentials")
        echo "$username" > $1
        echo "$password" >> $1
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
