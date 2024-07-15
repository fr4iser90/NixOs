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
    read -p "Do you want to proceed with installing the necessary packages? [y/N]: " response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        printf "Installation aborted by the user.\n" >&2
        exit 0
    fi

    if ! command -v lspci > /dev/null; then
        printf "Installing pciutils...\n"
        if ! nix-env -iA nixos.pciutils; then
            printf "pciutils installation failed.\n" >&2
            exit 1
        fi
    fi

    if ! command -v mkpasswd > /dev/null; then
        printf "Installing mkpasswd...\n"
        if ! nix-env -iA nixos.mkpasswd; then
            printf "mkpasswd installation failed.\n" >&2
            exit 1
        fi
    fi

    if ! command -v fzf > /dev/null; then
        printf "Installing fzf...\n"
        if ! nix-env -iA nixos.fzf; then
            printf "fzf installation failed.\n" >&2
            exit 1
        fi
    fi
}

# Check dependencies before proceeding
check_dependencies

# Execute checkGPU.sh
if [[ -f ./build/checkGPU.sh ]]; then
    printf "Running checkGPU.sh...\n"
    if ! source ./build/checkGPU.sh; then
        printf "Failed to run checkGPU.sh.\n" >&2
        exit 1
    fi
else
    printf "checkGPU.sh not found.\n" >&2
    exit 1
fi

# Execute envBuilder.sh
if [[ -f ./build/envBuilder.sh ]]; then
    printf "Running envBuilder.sh...\n"
    if ! source ./build/envBuilder.sh; then
        printf "Failed to run envBuilder.sh.\n" >&2
        exit 1
    fi
else
    printf "envBuilder.sh not found.\n" >&2
    exit 1
fi

# Execute hashPassword.sh
if [[ -f ./build/hashPassword.sh ]]; then
    printf "Running hashPassword.sh...\n"
    if ! source ./build/hashPassword.sh; then
        printf "Failed to run hashPassword.sh.\n" >&2
        exit 1
    fi
else
    printf "hashPassword.sh not found.\n" >&2
    exit 1
fi

# Re-run the script with sudo for the root part
printf "Re-running script with sudo for root operations...\n"
exec sudo bash ./build_root.sh
