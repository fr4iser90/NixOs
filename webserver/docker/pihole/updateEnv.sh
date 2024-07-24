#!/bin/bash

BASE_DIR="/home/docker/docker/pihole"
ENV_FILE="pihole.env"

# Function to generate a new web password using nix-shell and openssl
generate_web_password() {
  echo "Generating a secure Pihole web password..."
  nix-shell -p openssl --run "openssl rand -base64 32"
}

# Generate the new web password
WEBPASSWORD=$(generate_web_password)

# Define the new values as an array of "KEY:VALUE" pairs
new_values=(
  "WEBPASSWORD:$WEBPASSWORD"
)

# Function to update the .env file
update_env_file() {
  if [ -f "$BASE_DIR/$ENV_FILE" ]; then
    echo "Updating $ENV_FILE in Pihole"
    for entry in "${new_values[@]}"; do
      local key="${entry%%:*}"
      local value="${entry#*:}"
      sed -i "s|^$key=.*|$key=$value|" "$BASE_DIR/$ENV_FILE"
    done
  else
    echo "File $BASE_DIR/$ENV_FILE does not exist" >&2
    exit 1
  fi
}

# Main execution
update_env_file

echo "Pihole environment file has been updated."
