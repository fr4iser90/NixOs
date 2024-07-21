#!/bin/bash

# Prompt the user for domain, email, and certification resolver email
read -p "Please enter the domain: " domain
read -p "Please enter the email: " email
read -p "Please enter the certification resolver email (or press enter to use the same email): " certEmail

# Use email as certEmail if certEmail is not provided
if [[ -z "$certEmail" ]]; then
    certEmail="$email"
fi

# Export the variables for use in other scripts
export DOMAIN="$domain"
export EMAIL="$email"
export CERT_EMAIL="$certEmail"

# Function to update .nix files with detected username, hostname, domain, email, and certEmail information
update_nix_files() {
    local domain="$DOMAIN"
    local email="$EMAIL"
    local certEmail="$CERT_EMAIL"
    shopt -s nullglob
    for nix_file in ./build/setups/*.nix; do
        if [[ -f "$nix_file" ]]; then
            sed -i -e "s/domain = \".*\"/domain = \"$domain\"/" \
                   -e "s/email = \".*\"/email = \"$email\"/" \
                   -e "s/certEmail = \".*\"/certEmail = \"$certEmail\"/" "$nix_file"
            if [[ $? -eq 0 ]]; then
                printf "Updated %s with detected and input information.\n" "$nix_file" >&2
            else
                printf "Failed to update %s.\n" "$nix_file" >&2
            fi
        fi
    done
}

# Call the function to update .nix files
update_nix_files
