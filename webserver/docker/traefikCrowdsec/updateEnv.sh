#!/bin/bash

BASE_DIR="/home/docker/docker/traefikCrowdsec"
ENV_FILE="crowdsec.env"
DNS_SCRIPT="dnsProvider.sh"

# Function to get the GID of the current user
get_gid() {
  USER_GID=$(id -g)
}

# Function to update the crowdsec env file
update_env_file() {
  if [ -f "$BASE_DIR/$ENV_FILE" ]; then
    echo "Updating $ENV_FILE in traefik with PGID=$USER_GID"
    sed -i "s|^PGID=.*|PGID=\"$USER_GID\"|" "$BASE_DIR/$ENV_FILE"
    sed -i "s|^COLLECTIONS=.*|COLLECTIONS=\"crowdsecurity/traefik crowdsecurity/http-cve crowdsecurity/whitelist-good-actors crowdsecurity/postfix crowdsecurity/dovecot crowdsecurity/nginx\"|" "$BASE_DIR/$ENV_FILE"
  else
    echo "File $BASE_DIR/$ENV_FILE does not exist" >&2
    exit 1
  fi
}

# Function to run the dnsProvide script
run_dns_script() {
  if [ -f "$BASE_DIR/$DNS_SCRIPT" ]; then
    echo "Running $DNS_SCRIPT"
    bash "$BASE_DIR/$DNS_SCRIPT"
  else
    echo "Script $BASE_DIR/$DNS_SCRIPT does not exist" >&2
    exit 1
  fi
}

# Main execution
get_gid
update_env_file
run_dns_script

echo "Traefik environment file has been updated and DNS script has been executed."
