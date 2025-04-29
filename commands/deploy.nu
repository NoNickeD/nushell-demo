#!/usr/bin/env nu

use ../lib/util.nu

export def main [subcmd: list<string>] {
    match ($subcmd.0?) {
        "status" => { deploy-status ($subcmd | skip 1) }
        "scale" => { deploy-scale ($subcmd | skip 1) }
        "restart" => { deploy-restart ($subcmd | skip 1) }
        _ => { print "Usage: k8snu deploy <status|scale|restart>" }
    }
}

export def deploy-status [args: list<string>] {
    if ($args | length) == 0 {
        print "Usage: k8snu deploy status <name> [namespace]"
        exit 1
    }
    let name = $args.0
    let ns = if ($args | length) > 1 { $args.1 } else { 
        # Try to find the deployment in all namespaces
        let deployments = (util json_from_kubectl ["get", "deployments", "-A"] | get items)
        let found = ($deployments | where metadata.name == $name | first)
        if ($found | is-empty) {
            print $"Deployment ($name) not found in any namespace"
            exit 1
        }
        $found.metadata.namespace
    }
    print $"Checking status of deployment ($name) in namespace ($ns)"
    kubectl rollout status $"deployment/($name)" -n $ns
}

export def deploy-scale [args: list<string>] {
    if ($args | length) < 2 {
        print "Usage: k8snu deploy scale <name> <replicas> [namespace]"
        exit 1
    }
    let name = $args.0
    let replicas = $args.1
    let ns = if ($args | length) > 2 { $args.2 } else { 
        # Try to find the deployment in all namespaces
        let deployments = (util json_from_kubectl ["get", "deployments", "-A"] | get items)
        let found = ($deployments | where metadata.name == $name | first)
        if ($found | is-empty) {
            print $"Deployment ($name) not found in any namespace"
            exit 1
        }
        $found.metadata.namespace
    }
    print $"Scaling deployment ($name) to ($replicas) replicas in namespace ($ns)"
    kubectl scale deployment $name --replicas $replicas -n $ns
}

export def deploy-restart [args: list<string>] {
    if ($args | length) == 0 {
        print "Usage: k8snu deploy restart <name> [namespace]"
        exit 1
    }
    let name = $args.0
    let ns = if ($args | length) > 1 { $args.1 } else { 
        # Try to find the deployment in all namespaces
        let deployments = (util json_from_kubectl ["get", "deployments", "-A"] | get items)
        let found = ($deployments | where metadata.name == $name | first)
        if ($found | is-empty) {
            print $"Deployment ($name) not found in any namespace"
            exit 1
        }
        $found.metadata.namespace
    }
    print $"Restarting deployment ($name) in namespace ($ns)"
    kubectl rollout restart $"deployment/($name)" -n $ns
}