#!/bin/sh

fzf=/opt/homebrew/bin/fzf
daemonize=/opt/homebrew/sbin/daemonize

(find /System/Library/CoreServices /System/Applications /Applications /System/Applications/Utilities -maxdepth 1 -name "*.app" ; find ~/bin/applications/ -maxdepth 1) | $fzf | while read path;do
    if (echo "$path" | grep '\.app$'); then
        open "$path"
    else
        # Use this program so the popup terminal can close
        $daemonize $path
    fi
done
