#!/usr/bin/env nu

use ../lib/util.nu

export def main [subcmd: list<string>] {
    match ($subcmd.0?) {
        "list" => { pods-list }
        "crashes" => { pods-crashes }
        "logs" => { pods-logs ($subcmd | skip 1) }
        "images" => { pods-images ($subcmd | skip 1) }
        _ => { print "Usage: k8snu pods <list|crashes|logs|images>" }
    }
}

export def pods-list [] {
    util ensure_kubectl_available
    let pods = (util json_from_kubectl ["get", "pods", "-A"] | get items)
    $pods | each { |pod| 
        let restart_count = if ($pod.status.containerStatuses? | length) > 0 {
            $pod.status.containerStatuses | each { |cs| $cs.restartCount } | math max
        } else { 0 }
        {
            namespace: $pod.metadata.namespace
            name: $pod.metadata.name
            phase: $pod.status.phase
            restarts: $restart_count
            age: $pod.metadata.creationTimestamp
        }
    }
}

export def pods-crashes [] {
    util ensure_kubectl_available
    let pods = (util json_from_kubectl ["get", "pods", "-A"] | get items)
    $pods | each { |pod| 
        let restart_count = if ($pod.status.containerStatuses? | length) > 0 {
            $pod.status.containerStatuses | each { |cs| $cs.restartCount } | math max
        } else { 0 }
        {
            namespace: $pod.metadata.namespace
            name: $pod.metadata.name
            phase: $pod.status.phase
            restarts: $restart_count
        }
    } | where { |pod| $pod.phase != "Running" or $pod.restarts > 3 }
}

export def pods-logs [args: list<string>] {
    if ($args | length) == 0 {
        print "Usage: k8snu pods logs <pod-name> [namespace]"
        exit 1
    }
    let pod = $args.0
    let ns = if ($args | length) > 1 { $args.1 } else { 
        # Try to find the pod in all namespaces
        print $"Searching for pod ($pod) across all namespaces..."
        let pods = (util json_from_kubectl ["get", "pods", "-A"] | get items)
        let found = ($pods | where metadata.name == $pod)
        if ($found | is-empty) {
            print $"Error: Pod ($pod) not found in any namespace"
            print "Available pods:"
            $pods | select metadata.name metadata.namespace | table
            exit 1
        }
        if ($found | length) > 1 {
            print $"Warning: Multiple pods found with name ($pod):"
            $found | select metadata.name metadata.namespace | table
            print "Please specify the namespace: k8snu pods logs <pod-name> <namespace>"
            exit 1
        }
        $found.0.metadata.namespace
    }
    print $"Fetching logs for pod ($pod) in namespace ($ns)..."
    kubectl logs $pod -n $ns
}

export def pods-images [args: list<string>] {
    util ensure_kubectl_available
    let ns = if ($args | is-empty) { "default" } else { $args.0 }
    let pods = (util json_from_kubectl ["get", "pods", "-n", $ns] | get items)
    $pods | each { |p| $p.spec.containers | each { |c| { name: $p.metadata.name, image: $c.image } } } | flatten
}