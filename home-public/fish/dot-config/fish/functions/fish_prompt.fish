function fish_prompt
    set -l last_returncode $status
    set -l symbol '$ '
    set -l color $fish_color_cwd
    if fish_is_root_user
        set symbol '# '
        set -q fish_color_cwd_root
        and set color $fish_color_cwd_root
    end

    set_color $color
    echo -n "$FISH_PROMPT_PREFIX"
    echo -n "$(date +%H:%M:%S) "
    if test $CMD_DURATION -gt 1000
        echo -n $CMD_DURATION"ms "
    end
    if test $last_returncode -ne 0
        set_color red
        echo -n "$last_returncode "
        set_color $color
    end
    echo -n (prompt_pwd)
    echo -n $symbol
    set_color normal
end
