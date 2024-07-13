#!/usr/bin/env bash

# Function to handle script interruption
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT

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

# Re-run the script with sudo for the root part
printf "Re-running script with sudo for root operations...\n"
exec sudo bash ./build_root.sh
