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

# Execute scripts using absolute paths based on PROJECT_DIR
execute_script() {
    local script_name="$1"
    local script_path="${PROJECT_DIR}/build/scripts/${script_name}"

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

# Check dependencies before proceeding
execute_script "checkDependencies.sh"

# Check host for information
execute_script "collectData.sh"

# Execute scripts
execute_script "envBuilder.sh"
execute_script "hashPassword.sh"

# Re-run the script with sudo for the root part
printf "Re-running script with sudo for root operations...\n"
exec sudo bash "${PROJECT_DIR}/build/scripts/copyConfiguration.sh"
