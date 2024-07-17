#!/usr/bin/env bash

# Function to handle script interruption
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT

# Determine script directory
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Function to uninstall dependencies
uninstall_dependencies() {
    printf "This script will uninstall pciutils, mkpasswd, and fzf.\n"

    uninstall_package() {
        local package="$1"

        if nix-env -q | grep -q "$package"; then
            printf "Uninstalling %s...\n" "$package"
            if ! nix-env -e "$package"; then
                printf "Failed to uninstall %s.\n" "$package" >&2
                return 1
            fi
        else
            printf "%s is not installed.\n" "$package"
        fi
    }

    uninstall_package "pciutils" || return 1
    uninstall_package "mkpasswd" || return 1
    uninstall_package "fzf" || return 1
}

# Uninstall dependencies
uninstall_dependencies
if [[ $? -ne 0 ]]; then
    printf "Uninstallation of dependencies failed. Exiting.\n" >&2
    exit 1
fi

printf "All specified dependencies have been uninstalled successfully.\n"
