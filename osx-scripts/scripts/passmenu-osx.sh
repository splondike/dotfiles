#!/usr/bin/env bash

file=$(mktemp)

/Users/stefansk/osx-scripts/scripts/itemselector.sh /Users/stefansk/osx-scripts/scripts/passmenu-osx-inner.sh $file
result=$(cat $file)
rm $file

[[ -n "$result" ]] || exit

username=$(echo -n "$result" | head -n 1)
password=$(echo -n "$result" | tail -n +2 | head -n 1)

skhd=/opt/homebrew/bin/skhd

$skhd --text "$username"
$skhd --key "tab"
$skhd --text "$password"
$skhd --key "return"
