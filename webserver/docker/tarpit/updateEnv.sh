#!/bin/bash

BASE_DIR="/home/docker/docker/tarpit"
ENV_FILE="grafana.env"

# Function to prompt for username and password
prompt_credentials() {
  while true; do
    read -p "Enter Grafana (WebInterface for tarpit/honypot) username: " username
    read -s -p "Enter Grafana password: " password
    echo
    read -s -p "Confirm Grafana password: " password_confirm
    echo

    if [ "$password" == "$password_confirm" ]; then
      echo "Username and password confirmed."
      break
    else
      echo "Passwords do not match. Please try again."
    fi
  done
}

# Function to update the Grafana env file
update_env_file() {
  if [ -f "$BASE_DIR/$ENV_FILE" ]; then
    echo "Updating $ENV_FILE in tarpit with username and password"
    sed -i "s|^GF_SECURITY_ADMIN_USER=.*|GF_SECURITY_ADMIN_USER=$username|" "$BASE_DIR/$ENV_FILE"
    sed -i "s|^GF_SECURITY_ADMIN_PASSWORD=.*|GF_SECURITY_ADMIN_PASSWORD=$password|" "$BASE_DIR/$ENV_FILE"
  else
    echo "File $BASE_DIR/$ENV_FILE does not exist" >&2
    exit 1
  fi
}

# Main execution
prompt_credentials
update_env_file

echo "Grafana environment file has been updated."
