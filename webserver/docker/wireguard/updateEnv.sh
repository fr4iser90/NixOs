#!/bin/bash

BASE_DIR="/home/docker/docker/wireguard"
ENV_FILE="$BASE_DIR/wireguard.env"

# Prompt for username and password
read -p "Enter WireGuard Username: " username
read -s -p "Enter WireGuard Password: " password
echo
read -s -p "Confirm WireGuard Password: " password_confirm
echo

# Check if the passwords match
if [ "$password" != "$password_confirm" ]; then
  echo "Passwords do not match. Please run the script again."
  exit 1
fi

# Write the credentials to wireguard.env
echo "WGUI_USERNAME=$username" > $ENV_FILE
echo "WGUI_PASSWORD=$password" >> $ENV_FILE

echo "wireguard.env has been updated successfully."
