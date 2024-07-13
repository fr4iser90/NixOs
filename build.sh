#!/usr/bin/env bash

# Function to handle script interruption
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT

# Execute checkGPU.fish
if [[ -f ./build/checkGPU.fish ]]; then
    printf "Running checkGPU.fish...\n"
    if ! source ./build/checkGPU.fish; then
        printf "Failed to run checkGPU.fish.\n" >&2
        exit 1
    fi
else
    printf "checkGPU.fish not found.\n" >&2
    exit 1
fi

# Execute envBuilder.fish
if [[ -f ./build/envBuilder.fish ]]; then
    printf "Running envBuilder.fish...\n"
    if ! source ./build/envBuilder.fish; then
        printf "Failed to run envBuilder.fish.\n" >&2
        exit 1
    fi
else
    printf "envBuilder.fish not found.\n" >&2
    exit 1
fi

# Re-run the script with sudo for the root part
printf "Re-running script with sudo for root operations...\n"
exec sudo bash ./build_root.sh
