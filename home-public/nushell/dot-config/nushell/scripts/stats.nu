export def quantiles [...quantiles: int]: list -> table {
    let sorted = $in | sort
    let qs = if ($quantiles | length) > 0 { $quantiles } else { [0.0 0.50 0.75 0.9 0.95 0.99 1.0] }

    let len = $sorted | length
    $qs | reduce --fold null {|q|
        let idx = ($len * $q | math floor)
        # $in | append [{q: $q, v: ($sorted | get {|x| ([$x ($len - 1)] | math min)})}]
        $in | append [{q: $q, v: ($sorted | get ([($len - 1) $idx] | math min))}]
    }
}
