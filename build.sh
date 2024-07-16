#!/usr/bin/env bash

# Function to handle script interruption
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT

# Determine script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# Function to check dependencies
check_dependencies() {
    printf "This script requires pciutils (lspci), mkpasswd, and fzf to function correctly.\n"
    read -p "Do you want to proceed with installing the necessary packages? [y/N]: " response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        printf "Installation aborted by the user.\n" >&2
        exit 0
    fi

    install_package() {
        local package="$1"
        printf "Installing %s...\n" "$package"
        if ! nix-env -iA nixos."$package"; then
            printf "%s installation failed.\n" "$package" >&2
            exit 1
        fi
    }

    if ! command -v lspci > /dev/null; then
        install_package pciutils
    fi

    if ! command -v mkpasswd > /dev/null; then
        install_package mkpasswd
    fi

    if ! command -v fzf > /dev/null; then
        install_package fzf
    fi
}

# Check dependencies before proceeding
check_dependencies

# Execute scripts using absolute paths based on SCRIPT_DIR
execute_script() {
    local script_name="$1"
    local script_path="${SCRIPT_DIR}/build/scripts/${script_name}"

    if [[ -f "$script_path" ]]; then
        printf "Running %s...\n" "$script_name"
        if ! source "$script_path"; then
            printf "Failed to run %s.\n" "$script_name" >&2
            exit 1
        fi
    else
        printf "%s not found.\n" "$script_name" >&2
        exit 1
    fi
}

# Execute checkGPU.sh
execute_script "checkGPU.sh"

# Execute envBuilder.sh
execute_script "envBuilder.sh"

# Execute hashPassword.sh
execute_script "hashPassword.sh"

# Re-run the script with sudo for the root part
printf "Re-running script with sudo for root operations...\n"
exec sudo bash "${SCRIPT_DIR}/build/scripts/copyConfiguration.sh"
