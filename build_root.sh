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

if ! hostName=$(printf "%s" "$env_file" | grep -oP '(?<=hostName = ").*?(?=")'); then
    printf "Failed to extract hostName from env.nix\n" >&2
    exit 1
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

# Prompt the user to confirm proceeding with deletion
printf "Do you really want to proceed with 'sudo rm -rf /etc/nixos'? Enter 'yes' to proceed: "
read -r confirm

if [[ "$confirm" != "yes" ]]; then
    printf "Aborting.\n" >&2
    exit 1
fi

# Remove old configuration
if ! sudo rm -rf /etc/nixos; then
    printf "Failed to remove /etc/nixos\n" >&2
    exit 1
fi

# Copy new configuration
if ! sudo cp -r ./nixos /etc/nixos; then
    printf "Failed to copy new configuration to /etc/nixos\n" >&2
    exit 1
fi

cd /etc/nixos || exit

# Run nixos-rebuild switch
if ! sudo nixos-rebuild switch --flake .#"$hostName" --show-trace; then
    printf "nixos-rebuild switch failed\n" >&2
    exit 1
fi
