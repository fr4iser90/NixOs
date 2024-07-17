#!/bin/bash

# Function to update .nix files with detected username and hostname information
update_nix_files() {
    local username="$1"
    local hostname="$2"
    shopt -s nullglob
    for nix_file in ./build/setups/*.nix; do
        if [[ -f "$nix_file" ]]; then
            sed -i -e "s/mainUser = \".*\"/mainUser = \"$username\"/" \
                   -e "s/hostName = \".*\"/hostName = \"$hostname\"/" "$nix_file"
            if [[ $? -eq 0 ]]; then
                printf "Updated %s with detected username and hostname information.\n" "$nix_file" >&2
            else
                printf "Failed to update %s.\n" "$nix_file" >&2
            fi
        fi
    done
}

# Function to get the current system's username
get_username() {
    local username
    username=$(whoami)
    if [[ -z "$username" ]]; then
        printf "Failed to get the username.\n" >&2
        return 1
    fi
    printf "%s" "$username"
}

# Function to get the current system's hostname
get_hostname() {
    local hostname
    hostname=$(hostname)
    if [[ -z "$hostname" ]]; then
        printf "Failed to get the hostname.\n" >&2
        return 1
    fi
    printf "%s" "$hostname"
}

main() {
    local username hostname

    if ! username=$(get_username); then
        exit 1
    fi

    if ! hostname=$(get_hostname); then
        exit 1
    fi

    update_nix_files "$username" "$hostname"
}

main "$@"
