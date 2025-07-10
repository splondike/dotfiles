export def column_order [...colnames: string, --hide-spacer]: table -> table {
    let firstcol = $in | columns | first

    # You can't move a column before itself, so use this as a new point of reference.
    let dummy = "dummy_column_for_ordering"

    # Hack to truncate the visual display of the table to just show the given columns by default.
    mut spacer = ":spacer:"
    for _ in 1..300 {
        $spacer += " "
    }

    $in |
        insert $dummy "" | move $dummy --before $firstcol |
        move ...$colnames --before $dummy |
        (if $hide_spacer {$in} else {insert $spacer "" | move $spacer --before $dummy}) |
        reject $dummy
}

export def no_spacer []: table -> table {
    let spacer = $in | columns | where {str starts-with ":spacer:"} | first
    $in | reject $spacer
}

# Cache the output of the given closure on the filesystem. Refetches if nocache == true
export def cache_result [category: string, name: string, nocache: bool, fetcher: closure]: nothing -> any {
    let CACHE_DIR = $"($env.HOME)/.cache/nushell-fetchers/($category)"
    let file = $"($CACHE_DIR)/($name).nuon"
    if (not $nocache) and ($file | path exists) {
        open $file
    } else {
        mkdir $CACHE_DIR
        let result = do $fetcher
        $result | save -f $file
        $result
    }
}

export def append_tables []: list -> table {
    reduce {|elt, acc| $acc | append $elt}
}

export def env_vars []: nothing -> record {
    let conf_home = $env | get --ignore-errors XDG_CONFIG_HOME | default $"($env.HOME)/.config/"
    let conf_script = $"($conf_home)/nushell/setup-env.nu"
    if ($conf_script | path exists) {
        ^$conf_script | from json
    } else {
        {}
    }
}
