#!/bin/bash

BASE_DIR="/home/docker/docker/owncloud"
ENV_FILE="mysql.env"

# Function to generate a new MySQL root password using nix-shell and openssl
generate_mysql_password() {
  nix-shell -p openssl --run "openssl rand -base64 32"
}

# Check if DOMAIN environment variable is set
if [ -z "$DOMAIN" ]; then
  echo "DOMAIN environment variable is not set" >&2
  exit 1
fi

# Use the DOMAIN environment variable
APACHE_SERVER_NAME="$DOMAIN"

# Generate the new MySQL root password
MYSQL_ROOT_PASSWORD=$(generate_mysql_password)

# Function to escape special characters for sed
escape_for_sed() {
  echo "$1" | sed -e 's/[\/&]/\\&/g'
}

# Escape special characters in the password for sed
MYSQL_ROOT_PASSWORD_ESCAPED=$(escape_for_sed "$MYSQL_ROOT_PASSWORD")

# Print the generated password and escaped password for debugging
echo "Generated MySQL root password: $MYSQL_ROOT_PASSWORD_ESCAPED"

# Define the new values as an array of "KEY:VALUE" pairs
new_values=(
  "MYSQL_ROOT_PASSWORD:$MYSQL_ROOT_PASSWORD_ESCAPED"
  "APACHE_SERVER_NAME:$APACHE_SERVER_NAME"
)

# Function to update the .env file
update_env_file() {
  if [ -f "$BASE_DIR/$ENV_FILE" ]; then
    echo "Updating $ENV_FILE in owncloud"
    for entry in "${new_values[@]}"; do
      key="${entry%%:*}"
      value="${entry#*:}"
      echo "Running: sed -i \"s|^$key=.*|$key=$value|\" \"$BASE_DIR/$ENV_FILE\""  # Debug print
      sed -i "s|^$key=.*|$key=$value|" "$BASE_DIR/$ENV_FILE"
    done
  else
    echo "File $BASE_DIR/$ENV_FILE does not exist" >&2
    exit 1
  fi
}

# Main execution
update_env_file

echo "OwnCloud environment file has been updated."
