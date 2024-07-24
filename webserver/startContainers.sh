#!/bin/bash

# Define the base directory
BASE_DIR="/home/docker/docker"

# Define the specific order for the first few directories to skip
EXCEPT=("traefikCrowdsec")

# Run docker-compose up in the remaining directories
for dir in "$BASE_DIR"/*; do
  dir_name=$(basename "$dir")
  
  # Skip the directories that should not be started
  if [[ " ${EXCEPT[@]} " =~ " ${dir_name} " ]]; then
    continue
  fi

  if [ -d "$dir" ]; then
    echo "Processing directory: $dir_name"
    
    # Check if updateEnv.sh exists and execute it
    if [ -f "$dir/updateEnv.sh" ]; then
      echo "Executing updateEnv.sh in $dir_name"
      (cd "$dir" && bash updateEnv.sh)
    fi
    
    # Start docker-compose
    echo "Starting docker-compose in $dir_name"
    (cd "$dir" && docker compose up -d)
  fi
done

echo "Docker Compose up completed in all directories."
echo "Open http://localhost:9000 for Portainer installation."
echo "Open https://organizer.${DOMAIN} for Organizr installation."
echo "Open https://owncloud.${DOMAIN} for OwnCloud installation."
echo "Claim your PlexClaimToken and install Plex."
(cd "$BASE_DIR/plex" && bash updateClaim.sh)