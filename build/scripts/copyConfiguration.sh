#!/usr/bin/env bash

# Ensure the script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
    printf "This script must be run as root\n" >&2
    exit 1
fi

# Load environment variables from env.nix using nix-instantiate and grep
if ! env_file=$(nix-instantiate --eval --strict ./nixos/env.nix); then
    printf "Failed to evaluate env.nix\n" >&2
    exit 1
fi

if ! mainUser=$(printf "%s" "$env_file" | grep -oP '(?<=mainUser = ").*?(?=")'); then
    printf "Failed to extract mainUser from env.nix\n" >&2
    exit 1
fi

guestUser=$(printf "%s" "$env_file" | grep -oP '(?<=guestUser = ").*?(?=")')

if ! hostName=$(printf "%s" "$env_file" | grep -oP '(?<=hostName = ").*?(?=")'); then
    printf "Failed to extract hostName from env.nix\n" >&2
    exit 1
fi

if ! webHosting=$(printf "%s" "$env_file" | grep -oP '(?<=webHosting = ").*?(?=")'); then
    printf "Failed to extract webHosting from env.nix\n" >&2
fi

if [[ -z "$mainUser" || -z "$hostName" ]]; then
    printf "mainUser or hostName is empty\n" >&2
    exit 1
fi

printf "Setup initialized for %s on host: %s\n" "$mainUser" "$hostName"

# Copy the hardware-configuration.nix to ./nixos/
if ! cp /etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix; then
    printf "Failed to copy hardware-configuration.nix\n" >&2
    exit 1
fi
printf "Copied hardware-configuration\n"

# Backup /etc/nixos with a timestamped folder
timestamp=$(date +%Y%m%d%H%M%S)
backupfolder="./backup-$timestamp"
mkdir -p "$backupfolder"
if ! cp -r /etc/nixos/* "$backupfolder"; then
    printf "Failed to create backup of /etc/nixos\n" >&2
    exit 1
fi

printf "Backup of /etc/nixos created at %s\n" "$backupfolder"

# Copy the homeMainUser.nix to home-<mainUser>.nix
if ! cp ./nixos/modules/homemanager/homeMainUser.nix "./nixos/modules/homemanager/home-$mainUser.nix"; then
    printf "Failed to copy homeMainUser.nix\n" >&2
    exit 1
fi
printf "Copied homeMainUser.nix to home-%s.nix\n" "$mainUser"

# Only copy the homeGuestUser.nix if guestUser is set
if [[ -n "$guestUser" ]]; then
    if ! cp ./nixos/modules/homemanager/homeGuestUser.nix "./nixos/modules/homemanager/home-$guestUser.nix"; then
        printf "Failed to copy homeGuestUser.nix\n" >&2
        exit 1
    fi
    printf "Copied homeGuestUser.nix to home-%s.nix\n" "$guestUser"
fi

# Prompt the user to confirm proceeding with deletion
confirm_deletion() {
    while true; do
        printf "Do you really want to proceed with 'sudo rm -rf /etc/nixos'? Enter 'yes' to proceed or 'no' to cancel: "
        read -r confirm

        case "$confirm" in
            yes)
                break
                ;;
            no)
                printf "Aborting.\n" >&2
                exit 1
                ;;
            *)
                printf "Invalid input. Please enter 'yes' to proceed or 'no' to cancel.\n" >&2
                ;;
        esac
    done
}

# Remove old configuration
remove_old_config() {
    if ! sudo rm -rf /etc/nixos; then
        printf "Failed to remove /etc/nixos\n" >&2
        exit 1
    fi
}

# Copy new configuration
copy_new_config() {
    if ! sudo cp -r ./nixos /etc/nixos; then
        printf "Failed to copy new configuration to /etc/nixos\n" >&2
        exit 1
    fi
}

copy_webserver_config() {
    if [[ -n "$guestUser" ]]; then
        local target_dir="/home/${guestUser}"
        local target_certs=(
            "/home/${guestUser}/docker/traefikCrowdsec/traefik/acme_letsencrypt.json"
            "/home/${guestUser}/docker/traefikCrowdsec/traefik/tls_letsencrypt.json"
        )

        # Remove existing target directory
        if ! sudo rm -rf "${target_dir}"; then
            printf "Failed to remove existing directory %s\n" "${target_dir}" >&2
            exit 1
        fi

        # Copy new configuration files
        if ! sudo cp -r ./webserver "${target_dir}"; then
            printf "Failed to copy new configuration to %s\n" "${target_dir}" >&2
            exit 1
        fi

        # Set ownership
        if ! sudo chown -R "${guestUser}:${guestUser}" "${target_dir}"; then
            printf "Failed to set ownership for %s\n" "${target_dir}" >&2
            exit 1
        fi

        # Set permissions
        if ! sudo chmod -R 755 "${target_dir}"; then
            printf "Failed to set permissions for %s\n" "${target_dir}" >&2
            exit 1
        fi

        # Set permissions for the certificates files
        for cert in "${target_certs[@]}"; do
            if ! sudo chmod 600 "${cert}"; then
                printf "Failed to set permissions for %s\n" "${cert}" >&2
                exit 1
            fi
        done
    fi
}



# Run nixos-rebuild switch
rebuild_nixos() {
    cd /etc/nixos || exit
    if ! sudo nixos-rebuild switch --flake .#"$hostName" --show-trace; then
        printf "nixos-rebuild switch failed\n" >&2
        exit 1
    fi
}

main() {
    confirm_deletion
    remove_old_config
    copy_new_config
    
    if [ "$webHosting" = "true" ]; then
    copy_webserver_config
fi
    rebuild_nixos
}

main "$@"
