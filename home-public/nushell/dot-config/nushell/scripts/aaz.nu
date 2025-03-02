use util.nu;

def standard_column_order []: table -> table {
    util column_order name subscription resourceGroup
}

def cache_result [name: string, nocache: bool, fetcher: closure]: nothing -> any {
    util cache_result "aaz" $name $nocache $fetcher
}

export def subscriptions []: nothing -> table {
    az account list | from json | util column_order name isDefault id
}

# Fetch all resources regardless of subscription. The given closure will be passed each subscription in turn and should return a table for each
def fetch_all_resources [fetcher: closure]: nothing -> table {
    subscriptions | each {|sub| do $fetcher $sub.name | from json | insert subscription $sub.name } | util append_tables
}

# Combines cache_result and fetch_all_resources
def cache_fetch_all [name: string, nocache: bool, fetcher:closure]: nothing -> any {
    cache_result $name $nocache {fetch_all_resources $fetcher}
}

export def "resourcegroups" [--nocache]: nothing -> table {
    cache_fetch_all "resourcegroups" $nocache {|sub| az group list --subscription $sub} | util column_order name subscription
}

export def "storageaccounts" [--nocache]: nothing -> table {
    cache_fetch_all "storageaccounts" $nocache {|sub| az storage account list --subscription $sub} | standard_column_order
}

export def "storagecontainers" [--nocache]: nothing -> table {
    cache_result "storagecontainers" $nocache {
        storageaccounts --nocache=$nocache | each {|sa|
            let result = az storage container list --auth-mode login --account-name $sa.name --subscription $sa.subscription | complete
            if $result.exit_code == 0 {
                $result.stdout | from json | insert storage_account_name $sa.name | insert subscription $sa.subscription | insert id {|c| $"($sa.id)/blobServices/default/containers/($c.name)"}
            } else {
                $result.stderr | print --stderr
                null
            }
        } | util append_tables
    } | util column_order subscription storage_account_name name | sort-by subscription storage_account_name name
}

export def "storageblobs" [--prefix: string="", --results-per-page: int=1000, --generate]: record -> table {
    let container = $in

    def inner [marker: string] {
        let results = az storage blob list --auth-mode login --container-name $container.name --account-name $container.storage_account_name --subscription $container.subscription --show-next-marker --marker $marker --prefix $prefix --num-results $results_per_page | from json

        let body = $results | filter {"container" in ($in | columns)} | 
            insert created_at {$in.properties.creationTime | into datetime } |
            insert content_length {$in.properties.contentLength | into filesize} |
            util column_order name content_length created_at
        let next = $results | filter {"nextMarker" in ($in | columns)} | first | get --ignore-errors nextMarker

        if $next != null {
            {
                out: $body,
                next: $next
            }
        } else {
            {
                out: $body
            }
        }
    }

    if $generate {
        generate { |x| inner $x } ""
    } else {
        let result = inner ""
        $result.out
    }
}

export def "keyvaults" [--nocache]: nothing -> table {
    cache_fetch_all "keyvaults" $nocache {|sub| az keyvault list --subscription $sub} | standard_column_order
}

export def "vnets" [--nocache]: nothing -> table {
    cache_fetch_all "vnets" $nocache {|sub| az network vnet list --subscription $sub} | standard_column_order
}

export def "subnets" [--nocache]: nothing -> table {
    cache_result "subnets" $nocache {
        vnets --nocache=$nocache | each {|vnet| az network vnet subnet list --vnet-name $vnet.name --resource-group $vnet.resourceGroup --subscription $vnet.subscription | from json | insert vnetId $vnet.id | insert vnetName $vnet.name | insert subscription $vnet.subscription } | append_tables
    } | util column_order name subscription vnetName id | move addressPrefix --before vnetName
}

export def "aks" [--nocache]: nothing -> table {
    cache_fetch_all "aks" $nocache {|sub| az aks list --subscription $sub} | standard_column_order
}

export def "publicips" [--nocache]: nothing -> table {
    cache_fetch_all "publicips" $nocache {|sub| az network public-ip list --subscription $sub}
}

export def "loadbalancers" [--nocache]: nothing -> table {
    let fetch_ips = {|x|
        let private = $x | get --ignore-errors frontendIPConfigurations.privateIPAddress
        let publicips = publicips
        let public = $x | get --ignore-errors frontendIPConfigurations.publicIPAddress | join $publicips id id | get ipAddress
        $public | append $private | compact
    }
    cache_fetch_all "loadbalancers" $nocache {|sub| az network lb list --subscription $sub} |
        each { insert allIPs $fetch_ips } |
        util column_order allIPs name subscription
}

export def "roleassignments" [--nocache]: nothing -> table {
    cache_fetch_all "roleassignments" $nocache {|sub| az role assignment list --all --subscription $sub}
}

export def "managedidentities" [--nocache]: nothing -> table {
    cache_fetch_all "managedidentities" $nocache {|sub| az identity list --subscription $sub} | move name type --after clientId
}

export def "serviceprincipals" [--nocache]: nothing -> table {
    cache_result "serviceprincipals" $nocache {az ad sp list --all | from json}
}

export def "apps" [--nocache]: nothing -> table {
    cache_result "apps" $nocache {az ad app list --all | from json} | util column_order id appId displayName
}

export def "groups" [--nocache]: nothing -> table {
    cache_result "groups" $nocache {az ad group list | from json}
}

export def "users" [--nocache]: nothing -> table {
    cache_result "users" $nocache {az ad user list | from json}
}

export def "allprincipals" [--nocache]: nothing -> table {
    let user_rec = users --nocache=$nocache | insert principalId {$in.id} | insert principalDisplayName {$in.displayName} | insert principalType user | select principalId principalDisplayName principalType
    let group_rec = groups --nocache=$nocache | insert principalId {$in.id} | insert principalDisplayName {$in.displayName} | insert principalType group | select principalId principalDisplayName principalType
    let sp_rec = serviceprincipals --nocache=$nocache | insert principalId {$in.id} | insert principalDisplayName {$in.displayName} | insert principalType sp | select principalId principalDisplayName principalType
    let id_rec = managedidentities --nocache=$nocache | insert principalDisplayName {$in.name} | insert principalType manid | select principalId principalDisplayName principalType

    $user_rec | append $group_rec | append $sp_rec | append $id_rec
}

# TODO: Still not getting all principals successfully, see aaz keyvaults | first | aaz iam for example
export def "iam" [--nocache]: any -> table {
    let assignments = match ($in | describe --no-collect -d | $in.type) {
        nothing => {
            roleassignments --nocache=$nocache
        },
        string => {
            let arg = $in
            let f = if ($arg | str starts-with "/") {
                {|x| $arg | str starts-with $x.scope}
            } else {
                {|x| $x.principalId == $arg }
            }
            roleassignments --nocache=$nocache | filter $f
        },
        record => {
            let arg = $in.id
            roleassignments --nocache=$nocache | filter {|x| $arg | str starts-with $x.scope}
        }
    }
    $assignments |
        join --left (allprincipals --nocache=$nocache) principalId principalId |
        each {|x| default $x.principalName principalDisplayName} |
        util column_order roleDefinitionName principalDisplayName principalType scope
}
