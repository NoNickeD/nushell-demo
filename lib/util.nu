#!/usr/bin/env nu

export def ensure_kubectl_available [] {
    if ((which kubectl) == null) {
        print "kubectl not found in PATH"
        exit 1
    }
}

export def json_from_kubectl [args: list<string>] {
    kubectl ...$args --output json | from json
}