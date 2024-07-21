#!/bin/bash

# Define the base directory
BASE_DIR="/etc/webserver/docker"
SECRETS_FILE="/etc/webserver/secrets.env"

# Define the specific order for the first few directories
ORDER=("cloudflare" "traefikCrowdsec" "portainer")

# Run docker-compose up in the specified order
for dir in "${ORDER[@]}"; do
  if [ -d "$BASE_DIR/$dir" ]; then
    echo "Starting docker-compose in $dir"
    (cd "$BASE_DIR/$dir" && docker compose up -d)
  else
    echo "Directory $dir does not exist in $BASE_DIR"
  fi
done

# Run docker-compose up in the remaining directories
for dir in "$BASE_DIR"/*; do
  dir_name=$(basename "$dir")
  
  # Skip the directories that have already been processed
  if [[ " ${ORDER[@]} " =~ " ${dir_name} " ]]; then
    continue
  fi

  if [ -d "$dir" ]; then
    echo "Starting docker-compose in $dir_name"
    (cd "$dir" && docker compose up -d)
  fi
done

echo "Docker compose up completed in all directories."
