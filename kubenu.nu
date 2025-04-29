#!/usr/bin/env nu

# Main entrypoint: kubenu.nu
# This file dispatches commands based on user input.

# Load subcommand modules
use lib/util.nu
use commands/cluster.nu
use commands/pods.nu
use commands/deploy.nu
use commands/cleanup.nu

# Dispatcher function
export def main [...args] {
    if ($args | is-empty) {
        print "Usage: k8snu <command> [subcommand] [args]"
        exit 1
    }

    let cmd = $args.0
    let subcmd = ($args | skip 1)

    match $cmd {
        "cluster" => { cluster $subcmd }
        "pods"    => { pods $subcmd }
        "deploy"  => { deploy $subcmd }
        "cleanup" => { cleanup $subcmd }
        _ => {
            print "Unknown command: ($cmd)"
            exit 1
        }
    }
}
