#!/usr/bin/env bash

# Function to handle script interruption
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT

# Function to check dependencies
check_dependencies() {
    printf "This script requires pciutils (lspci), mkpasswd, and fzf to function correctly.\n"

    check_and_install() {
        local package command response
        package="$1"
        command="$2"
        
        if ! command -v "$command" > /dev/null; then
            printf "%s is not installed.\n" "$package"
            read -p "Do you want to proceed with installing $package? [y/N]: " response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                printf "Installing %s...\n" "$package"
                if ! nix-env -iA nixos."$package"; then
                    printf "%s installation failed.\n" "$package" >&2
                    return 1
                fi
            else
                printf "Installation of %s aborted by the user.\n" "$package" >&2
                return 1
            fi
        fi
    }

    check_and_install "pciutils" "lspci" || return 1
    check_and_install "mkpasswd" "mkpasswd" || return 1
    check_and_install "fzf" "fzf" || return 1
}

# Check dependencies before proceeding
check_dependencies
if [[ $? -ne 0 ]]; then
    printf "Dependency check failed. Exiting.\n" >&2
    exit 1
fi
