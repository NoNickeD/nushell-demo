#!/usr/bin/env nu

use ../lib/util.nu

export def main [subcmd: list<string>] {
    match ($subcmd.0?) {
        "info" => { cluster-info }
        "health" => { cluster-health }
        _ => { print "Usage: k8snu cluster <info|health>" }
    }
}

export def cluster-info [] {
    util ensure_kubectl_available
    print "Kubernetes Version:"
    kubectl version | lines | each { |line| if $line =~ "GitVersion" { print $line } }
    print "\nNodes:"
    kubectl get nodes -o wide
}

export def cluster-health [] {
    util ensure_kubectl_available
    let nodes = (util json_from_kubectl ["get", "nodes"] | get items)
    let not_ready = ($nodes | where { |node| 
        let ready_condition = ($node.status.conditions | where type == "Ready" | first)
        $ready_condition.status != "True"
    })
    if ($not_ready | length) == 0 {
        print "✅ All nodes are Ready"
    } else {
        print "❌ Some nodes not Ready:"
        $not_ready | each { |node| print $"  ($node.metadata.name)" }
    }
}