#!/bin/bash

# Stop all running Docker containers
echo "Stopping all running Docker containers..."
docker stop $(docker ps -aq)

# Remove all Docker containers
echo "Removing all Docker containers..."
docker rm $(docker ps -aq)

# Remove all Docker networks
echo "Removing all Docker networks..."
docker network rm $(docker network ls -q)

# Remove all Docker volumes
echo "Removing all Docker volumes..."
docker volume rm $(docker volume ls -q)

# Remove all Docker images
echo "Removing all Docker images..."
docker rmi $(docker images -q)

echo "All Docker containers, networks, volumes, and images have been removed."

# Optionally, you can also prune the system to remove unused data
# docker system prune -a --volumes --force

echo "Docker system prune completed."
