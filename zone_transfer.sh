#!/bin/env bash

domain=''

parse_flag() {
    while [[ -n "$1" ]]; do
        case "$1" in
            -d | --domain) shift
                            domain="$1"
                            ;;
            -h | --help)    help
                            exit
                            ;;
            -v | --version) version
                            exit
                            ;;
            *)              help >&2
                            exit 1
                            ;;
        esac
        shift
    done
}

help() {
    echo "This script is designed to check for zone transfer..
Usage: zone_transfer.sh [OPTIONS]

    -d, --domain       (required) Set a domain to check for zone transfer
    -h, --help          display this help and exit
"
    exit 0
}

version() {
    echo "zone_transfer 0.1.0"
}

check_params() {
    if [ -z "$domain" ]; then
        help
        exit
    fi
}

check_zone() {
    for n in $(dig +short NS $domain); do dig -t axfr $domain @$n; done
}

# main()
parse_flag "$@"
check_params
check_zone