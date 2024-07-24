#!/usr/bin/env bash

# Function to handle script interruption
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT

# Determine the directory of the current script (the directory where this script is located)
PROJECT_DIR="$(cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")" && pwd)"

# Change to the project directory
cd "$PROJECT_DIR" || { printf "Failed to change directory to %s.\n" "$PROJECT_DIR" >&2; exit 1; }

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

# Execute envBuilder.sh and decide predefined or personalized setup
execute_script "envBuilder.sh"

if [[ "$SETUP_TYPE" == "predefined" ]]; then
    execute_script "predefinedSetup.sh"
else
    execute_script "personalizedSetup.sh"
fi

# Collect email / domain if wanted
execute_script "collectPersonalData.sh"

# Execute hash password script
execute_script "hashPassword.sh"

# Re-run the script with sudo for the root part
printf "Re-running script with sudo for root operations...\n"
exec sudo bash "${PROJECT_DIR}/build/scripts/copyConfiguration.sh"
