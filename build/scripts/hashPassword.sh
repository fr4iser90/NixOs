#!/bin/bash

set -e

# Function to hash the password
hash_password() {
    local password="$1"
    echo "$password" | mkpasswd -m sha-512 -s
}

# Check if mkpasswd is installed
if ! command -v mkpasswd &> /dev/null; then
    echo "Installing mkpasswd..."
    nix-env -iA nixpkgs.whois
fi

# Prompt for the password and ensure it's not empty
while true; do
    read -sp "Please enter a password: " password
    echo
    if [[ -z "$password" ]]; then
        echo "Password cannot be empty. Please try again."
        continue
    fi

    read -sp "Please confirm the password: " password_confirm
    echo

    # Verify that the passwords match
    if [[ "$password" != "$password_confirm" ]]; then
        echo "Passwords do not match. Please try again."
    else
        break
    fi
done

# Define the target directory
OUTPUT_DIR="./nixos/secrets/passwords"
OUTPUT_FILE="$OUTPUT_DIR/.hashedLoginPassword"

# Delete the existing password file if it exists
if [[ -f "$OUTPUT_FILE" ]]; then
    rm "$OUTPUT_FILE"
fi

# Create the directory if it does not exist
mkdir -p "$OUTPUT_DIR"

# Hash the password
hashed_password=$(hash_password "$password")

# Save the hashed password to the file
printf "%s\n" "$hashed_password" > "$OUTPUT_FILE"

printf "The password has been successfully hashed and saved to %s.\n" "$OUTPUT_FILE"
echo "The hashed password is stored in $OUTPUT_FILE and can be used for new users to set up their login credentials."
