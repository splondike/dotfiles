# Gitlab functions

use util.nu

def build_url [url: string]: nothing -> string {
    $"https://gitlab.com/api/v4($url)"
}

def "api get" [url_fragment: string]: nothing -> table {
    let url = (build_url $url_fragment)
    http get --full --headers [Authorization $"Bearer ($env.GITLAB_ACCESS_TOKEN)"] $url
}

export def "runner jobs" [runner_id?: string, --generate]: nothing -> any {
    def inner [page: string] {
        let final_runner_id = $runner_id | default $env.GITLAB_RUNNER_ID
        let url = $"/runners/($final_runner_id)/jobs?order_by=id&sort=desc&page=($page)"
        let result = api get $url
        def getheader [name]: nothing -> string {
            $result.headers.response | where {$in.name == $name} | get value | first
        }
        # project name status created_at
        let body = $result.body |
            insert project_name {$in.project.name} |
            insert project_id {$in.project.id} |
            update created_at {into datetime} |
            update queued_duration {into int | $"($in)sec" | into duration} |
            update duration {into int | $"($in)sec" | into duration} |
            util column_order created_at project_name status duration id project_id

        let next_page = getheader "x-next-page"
        if $next_page == "" {
            {
                out: $body
            }
        } else {
            {
                out: $body,
                next: $next_page
            }
        }
    }

    if $generate {
        generate { |x| inner $x } "1"
    } else {
        let result = inner "1"
        $result.out
    }
}

export def "job log" [project_id: string, job_id: string]: nothing -> string {
    let result = api get $"/projects/($project_id)/jobs/($job_id)/trace"
    $result.body
}
