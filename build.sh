#!/usr/bin/env bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Load environment variables from env.nix using nix-instantiate and grep
env_file=$(nix-instantiate --eval --strict ./nixos/env.nix)

mainUser=$(echo "$env_file" | grep -oP '(?<=mainUser = ").*?(?=")')
hostName=$(echo "$env_file" | grep -oP '(?<=hostName = ").*?(?=")')

# Check if mainUser and hostName are correctly set
if [[ -z "$mainUser" || -z "$hostName" ]]; then
  echo "Failed to extract environment variables from env.nix"
  exit 1
fi

# Prompt to change mainUser
echo "Current mainUser: $mainUser"
read -p "Do you want to change mainUser? Enter new value or press Enter to keep the current value: " newMainUser

if [[ -n "$newMainUser" ]]; then
  mainUser=$newMainUser
  sed -i -e "s/mainUser = \".*\"/mainUser = \"$mainUser\"/" ./nixos/env.nix
  echo "Updated mainUser to $mainUser in env.nix"
fi

# Prompt to change hostName
echo "Current hostName: $hostName"
read -p "Do you want to change hostName? Enter new value or press Enter to keep the current value: " newHostName

if [[ -n "$newHostName" ]]; then
  hostName=$newHostName
  sed -i -e "s/hostName = \".*\"/hostName = \"$hostName\"/" ./nixos/env.nix
  echo "Updated hostName to $hostName in env.nix"
fi

echo "Setup initialized for $mainUser on host: $hostName"
# Copy the hardware-configuration.nix to ./nixos/
cp /etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix
echo "Copied hardware-configuration"

# Backup /etc/nixos with a timestamped folder
timestamp=$(date +%Y%m%d%H%M%S)
backupfolder=./backup-$timestamp
mkdir -p $backupfolder
cp -r /etc/nixos/* $backupfolder

echo "Backup of /etc/nixos created at $backupfolder"

# Copy the homeMainUser.nix to home-<mainUser>.nix
cp ./nixos/modules/homemanager/homeMainUser.nix ./nixos/modules/homemanager/home-$mainUser.nix
echo "Copied homeMainUser.nix to home-$mainUser.nix"

# Prompt the user to confirm proceeding with deletion
read -p "Do you really want to proceed with 'sudo rm -rf /etc/nixos'? Enter 'yes' to proceed: " confirm

if [[ "$confirm" != "yes" ]]; then
  echo "Aborting."
  exit 1
fi

# Remove old configuration
sudo rm -rf /etc/nixos
# Copy new configuration
sudo cp -r ./nixos /etc/nixos
cd /etc/nixos
# Run nixos-rebuild switch
sudo nixos-rebuild switch --flake .#$hostName --show-trace
