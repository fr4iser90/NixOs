#!/bin/bash

# Start Traefik
echo "Starting Traefik..."
bash startTraefik.sh

# Check if startTraefik.sh executed successfully
if [ $? -ne 0 ]; then
  echo "Failed to start Traefik. Exiting."
  exit 1
fi

# Start other containers
echo "Starting other containers..."
bash startContainers.sh

# Check if startContainers.sh executed successfully
if [ $? -ne 0 ]; then
  echo "Failed to start containers. Exiting."
  exit 1
fi

echo "All services started successfully."
