#!/bin/bash

BASE_DIR="/home/docker/docker/plex"
ENV_FILE="$BASE_DIR/plex.env"

# Function to prompt the user for the PLEX_CLAIM token
prompt_claim_token() {
  echo "Please open https://plex.${DOMAIN}/claim and copy the token"
  read -p "Enter the new PLEX_CLAIM token: " PLEX_CLAIM
  echo "$PLEX_CLAIM"
}

# Function to escape special characters for sed
escape_for_sed() {
  echo "$1" | sed -e 's/[\/&]/\\&/g'
}

# Prompt the user for the PLEX_CLAIM token
PLEX_CLAIM=$(prompt_claim_token)

# Escape the PLEX_CLAIM token for sed
PLEX_CLAIM_ESCAPED=$(escape_for_sed "$PLEX_CLAIM")

# Update the PLEX_CLAIM in the env file
if [ -f "$ENV_FILE" ]; then
  echo "Updating $ENV_FILE with PLEX_CLAIM"
  sed -i "s/^PLEX_CLAIM=.*/PLEX_CLAIM=$PLEX_CLAIM_ESCAPED/" "$ENV_FILE"
else
  echo "File $ENV_FILE does not exist" >&2
  exit 1
fi

echo "$ENV_FILE has been updated with the new PLEX_CLAIM: $PLEX_CLAIM"
