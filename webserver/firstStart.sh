#!/bin/bash

# Define the base directory
BASE_DIR="/etc/webserver/docker"
SECRETS_FILE="/etc/webserver/secrets.env"

# Load environment variables from secrets.env if it exists
if [ -f "$SECRETS_FILE" ]; then
  export $(grep -v '^#' "$SECRETS_FILE" | xargs)
fi

# Define the specific order for the first few directories
ORDER=("cloudflare" "traefikCrowdsec" "portainer")

# Run docker-compose up in the specified order
for dir in "${ORDER[@]}"; do
  if [ -d "$BASE_DIR/$dir" ]; then
    echo "Starting docker-compose in $dir"
    (cd "$BASE_DIR/$dir" && docker compose up -d)
    
    if [ "$dir" == "traefikCrowdsec" ]; then
      echo "Waiting for Traefik to start..."
      sleep 30  # Adjust the sleep duration as needed

      echo "Generating new bouncer API key in CrowdSec..."
      CROWDSEC_API_KEY=$(docker exec crowdsec cscli bouncers add my-bouncer | grep 'API key:' | awk '{print $3}')
      
      if [ -z "$CROWDSEC_API_KEY" ]; then
        echo "Failed to generate CrowdSec bouncer API key" >&2
        exit 1
      fi

      echo "Updating traefik-crowdsec-bouncer.env with new API key..."
      BOUNCER_ENV_FILE="$BASE_DIR/traefikCrowdsec/traefik-crowdsec-bouncer.env"
      sed -i "s/^CROWDSEC_BOUNCER_API_KEY=.*/CROWDSEC_BOUNCER_API_KEY=$CROWDSEC_API_KEY/" "$BOUNCER_ENV_FILE"
    fi
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
