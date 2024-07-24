#!/bin/bash

TEMP_FILE="/tmp/script_last_values"

# Load last values if they exist
if [[ -f "$TEMP_FILE" ]]; then
    source "$TEMP_FILE"
fi

# Function to prompt for a value, allowing the user to press enter to keep the existing value
prompt_for_value() {
    local prompt_text="$1"
    local var_name="$2"
    local default_value="$3"

    read -p "$prompt_text ($default_value): " input_value
    if [[ -z "$input_value" ]]; then
        input_value="$default_value"
    fi

    eval "$var_name=\"$input_value\""
}

# Prompt the user for domain, email, and certification resolver email
echo "Enter domain email etc if you want, or add it manually to modules if needed"
prompt_for_value "Please enter the email" email "$EMAIL"
prompt_for_value "Please enter the domain" domain "$DOMAIN"
prompt_for_value "Please enter the certification resolver email (or press enter to use the same email)" certEmail "$CERT_EMAIL"

# Use email as certEmail if certEmail is not provided
if [[ -z "$certEmail" ]]; then
    certEmail="$email"
fi

# Export the variables for use in other scripts
export DOMAIN="$domain"
export EMAIL="$email"
export CERT_EMAIL="$certEmail"

# Save the values to a temp file
echo "DOMAIN=\"$domain\"" > "$TEMP_FILE"
echo "EMAIL=\"$email\"" >> "$TEMP_FILE"
echo "CERT_EMAIL=\"$certEmail\"" >> "$TEMP_FILE"

# Function to update .nix files with detected username, hostname, domain, email, and certEmail information
update_nix_files() {
    local domain="$DOMAIN"
    local email="$EMAIL"
    local certEmail="$CERT_EMAIL"
    shopt -s nullglob
    for nix_file in ./build/setups/*.nix; do
        if [[ -f "$nix_file" ]]; then
            sed -i -e "s/\(domain = \).*/\1\"$domain\";/" \
                   -e "s/\(email = \).*/\1\"$email\";/" \
                   -e "s/\(certEmail = \).*/\1\"$certEmail\";/" "$nix_file"
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
