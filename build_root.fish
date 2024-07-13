#!/usr/bin/env fish

# Ensure the script is run as root
if test (id -u) -ne 0
  echo "This script must be run as root"
  exit 1
end

# Load environment variables from env.nix using nix-instantiate and sed
set -l env_file (nix-instantiate --eval --strict ./nixos/env.nix)

set -lx mainUser (echo $env_file | grep -oP '(?<=mainUser = ").*?(?=")')
set -lx hostName (echo $env_file | grep -oP '(?<=hostName = ").*?(?=")')

# Check if mainUser and hostName are correctly set
if test -z "$mainUser" -o -z "$hostName"
  echo "Failed to extract environment variables from env.nix"
  exit 1
end

echo "Setup initialized for $mainUser on host: $hostName"

# Copy the hardware-configuration.nix to ./nixos/
cp /etc/nixos/hardware-configuration.nix ./nixos/hardware-configuration.nix
echo "Copied hardware-configuration"

# Backup /etc/nixos with a timestamped folder
set -l timestamp (date +%Y%m%d%H%M%S)
set -l backupfolder ./backup-$timestamp
mkdir -p $backupfolder
cp -r /etc/nixos/* $backupfolder

echo "Backup of /etc/nixos created at $backupfolder"

# Copy the homeMainUser.nix to home-<mainUser>.nix
cp ./nixos/modules/homemanager/homeMainUser.nix ./nixos/modules/homemanager/home-$mainUser.nix
echo "Copied homeMainUser.nix to home-$mainUser.nix"

# Prompt the user to confirm proceeding with deletion
echo "Do you really want to proceed with 'sudo rm -rf /etc/nixos'? Enter 'yes' to proceed:"
read -l confirm

if test "$confirm" != "yes"
  echo "Aborting."
  exit 1
end

# Remove old configuration
sudo rm -rf /etc/nixos

# Copy new configuration
sudo cp -r ./nixos /etc/nixos

cd /etc/nixos

# Run nixos-rebuild switch
sudo nixos-rebuild switch --flake .#$hostName --show-trace
