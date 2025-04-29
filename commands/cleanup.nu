#!/usr/bin/env nu

use ../lib/util.nu

export def main [subcmd: list<string>] {
    match ($subcmd.0?) {
        "evicted" => { cleanup-evicted }
        "jobs" => { cleanup-jobs ($subcmd | skip 1) }
        _ => { print "Usage: k8snu cleanup <evicted|jobs>" }
    }
}

export def cleanup-evicted [] {
    util ensure_kubectl_available
    let pods = (util json_from_kubectl ["get", "pods", "-A"] | get items)
    $pods | each { |pod| 
        {
            name: $pod.metadata.name
            namespace: $pod.metadata.namespace
            reason: $pod.status.reason?
        }
    } | where reason == "Evicted" | each { |p| 
        print $"Deleting evicted pod ($p.name) in namespace ($p.namespace)"
        kubectl delete pod $p.name -n $p.namespace
    }
}

export def cleanup-jobs [args: list<string>] {
    util ensure_kubectl_available
    let days = if ($args | length) >= 2 and $args.0 == "--older-than" {
        $args.1 | into int
    } else {
        7  # default to 7 days
    }
    let jobs = (util json_from_kubectl ["get", "jobs", "-A"] | get items)
    let cutoff = (date now) - ($days * 24 * 60 * 60 * 1_000_000_000)
    $jobs | where status.succeeded == 1 and (status.completionTime | into datetime) < $cutoff | each { |j| kubectl delete job ($j.metadata.name) -n ($j.metadata.namespace) }
}