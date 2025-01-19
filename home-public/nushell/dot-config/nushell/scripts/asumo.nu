def build_url [url_fragment: string]: nothing -> string {
    $"https://api.au.sumologic.com/api($url_fragment)"
    # $"http://localhost:8000/api($url_fragment)"
}

def "api get" [url_fragment: string]: nothing -> table {
    let url = (build_url $url_fragment)
    http get --full --user $env.SUMOLOGIC_CLIENT_ID --password $env.SUMOLOGIC_CLIENT_SECRET $url
}

def "api post" [url_fragment: string, data_dict: any]: nothing -> table {
    let url = (build_url $url_fragment)
    let data = ($data_dict | to json -r)
    http post --full --user $env.SUMOLOGIC_CLIENT_ID --password $env.SUMOLOGIC_CLIENT_SECRET --headers [Accept application/json Content-Type application/json] $url $data
}

def "create search job" [query: string, from: string, to: string, timeZone: string]: nothing -> string {
    let response = api post "/v1/search/jobs" {query: $query, from: $from, to: $to, timeZone: $timeZone}
    $response.headers | get Location
}

def absolute_time [x: any]: nothing -> string {
    def fmt [] {
        format date "%Y-%m-%dT%H:%M:%S"
    }
    match ($x | describe --no-collect -d | $in.type) {
        date => ($x | fmt)
        duration => {
            (date now) - $x | fmt
        }
        string => $x
    }
}

export def query [
    query: string,
    --start: any=15min,
    --end: any=0sec,
    --timezone: string="Australia/Melbourne"
]: nothing -> table {
    let start_abs = absolute_time $start
    let end_abs = absolute_time $end
    let status_url = create search job $query $start_abs $end_abs $timezone

    # TODO: My account type isn't able to do this
    $status_url | print
    # for $x in 1..60 {
    #     sleep 1sec
    # }
    ls
}
