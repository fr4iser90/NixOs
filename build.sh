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

# Function to check dependencies
check_dependencies() {
    printf "This script requires pciutils (lspci), mkpasswd, and fzf to function correctly.\n"
    
    check_and_install() {
        local package="$1"
        local command="$2"
        
        if ! command -v "$command" > /dev/null; then
            printf "%s is not installed.\n" "$package"
            read -p "Do you want to proceed with installing %s? [y/N]: " "$package" response
            if [[ "$response" =~ ^[Yy]$ ]]; then
                printf "Installing %s...\n" "$package"
                if ! nix-env -iA nixos."$package"; then
                    printf "%s installation failed.\n" "$package" >&2
                    exit 1
                fi
            else
                printf "Installation of %s aborted by the user.\n" "$package" >&2
                exit 0
            fi
        fi
    }

    check_and_install "pciutils" "lspci"
    check_and_install "mkpasswd" "mkpasswd"
    check_and_install "fzf" "fzf"
}

# Check dependencies before proceeding
check_dependencies

# Execute scripts using absolute paths based on PROJECT_DIR
execute_script() {
    local script_name="$1"
    local script_path="${PROJECT_DIR}/build/scripts/${script_name}"
    local script_dir="${PROJECT_DIR}/build/scripts"

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

# Execute checkLocale.sh
execute_script "checkLocale.sh"

# Execute envBuilder.sh
execute_script "envBuilder.sh"

# Execute hashPassword.sh
execute_script "hashPassword.sh"

# Re-run the script with sudo for the root part
printf "Re-running script with sudo for root operations...\n"
exec sudo bash "${PROJECT_DIR}/build/scripts/copyConfiguration.sh"
