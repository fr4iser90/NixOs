#!/bin/bash

BASE_DIR="/home/docker/docker/portainer"
COMPOSE_FILE="docker-compose.yml"

# Function to get the UID and GID of the current user
get_uid_gid() {
  USER_UID=$(id -u)
  USER_GID=$(id -g)
}

# Function to update the Docker Compose file
update_compose_file() {
  if [ -f "$BASE_DIR/$COMPOSE_FILE" ]; then
    echo "Updating $COMPOSE_FILE in portainer with UID=$USER_UID and GID=$USER_GID"
    sed -i "s|PUID: '[0-9]*'|PUID: '$USER_UID'|" "$BASE_DIR/$COMPOSE_FILE"
    sed -i "s|PGID: '[0-9]*'|PGID: '$USER_GID'|" "$BASE_DIR/$COMPOSE_FILE"
  else
    echo "File $BASE_DIR/$COMPOSE_FILE does not exist" >&2
    exit 1
  fi
}

# Main execution
get_uid_gid
update_compose_file

echo "Portainer Docker Compose file has been updated."
