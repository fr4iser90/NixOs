#!/bin/bash

BASE_DIR="/home/docker/docker/bitwarden"
ENV_FILE="bw.env"

# Function to generate a random salt using openssl via nix-shell
generate_salt() {
  nix-shell -p openssl --run "openssl rand -base64 16"
}

# Function to hash the admin token using libargon2 via nix-shell
hash_admin_token() {
  local password=$1
  local salt=$(generate_salt)
  nix-shell -p libargon2 --run "echo -n '$password' | argon2 '$salt' -id -t 2 -m 16 -p 1" | grep -Eo '\$argon2id\$[^\s]+'
}

# Function to prompt the user for a password
prompt_password() {
  while true; do
    read -sp "Enter the admin password for bitwarden: " password1
    echo
    read -sp "Confirm the admin password for bitwarden: " password2
    echo
    if [ "$password1" == "$password2" ]; then
      echo "$password1"
      return
    else
      echo "Passwords do not match. Please try again."
    fi
  done
}

# Check if DOMAIN environment variable is set
if [ -z "$DOMAIN" ]; then
  echo "DOMAIN environment variable is not set" >&2
  exit 1
fi

# Use the DOMAIN environment variable
DOMAIN_SUFFIX="$DOMAIN"

# Prompt the user for the admin password
admin_password=$(prompt_password)

# Hash the admin password
ADMIN_TOKEN=$(hash_admin_token "$admin_password")

# Function to escape special characters for sed
escape_for_sed() {
  echo "$1" | sed -e 's/[\/&]/\\&/g'
}

# Escape special characters in the token for sed
ADMIN_TOKEN_ESCAPED=$(escape_for_sed "$ADMIN_TOKEN")

# Define the new values as an array of "KEY:VALUE" pairs
new_values=(
  "ADMIN_TOKEN:$ADMIN_TOKEN_ESCAPED"
  "DOMAIN:https://bw.$DOMAIN_SUFFIX"
  "WEBSOCKET_ENABLED:true"
)

# Function to update the .env file
update_env_file() {
  if [ -f "$BASE_DIR/$ENV_FILE" ]; then
    echo "Updating $ENV_FILE in bitwarden"
    for entry in "${new_values[@]}"; do
      local key="${entry%%:*}"
      local value="${entry#*:}"
      echo "Running: sed -i \"s|^$key=.*|$key=$value|\" \"$BASE_DIR/$ENV_FILE\""  # Debug print
      sed -i "s|^$key=.*|$key=$value|" "$BASE_DIR/$ENV_FILE"
    done
  else
    echo "File $BASE_DIR/$ENV_FILE does not exist" >&2
  fi
}

# Main execution
update_env_file

echo "Bitwarden environment file has been updated. AdminToken : $ADMIN_TOKEN"
