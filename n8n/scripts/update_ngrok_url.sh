#!/bin/bash

set -e  # Exit on any error

# Define path variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ENV_FILE="$PROJECT_ROOT/.env"
COMPOSE_FILE="$PROJECT_ROOT/docker-compose.yml"

# Fetch the current public HTTPS ngrok URL
NGROK_URL=$(curl --silent http://localhost:4040/api/tunnels | \
  jq -r '.tunnels[] | select(.proto=="https") | .public_url')

if [ -z "$NGROK_URL" ]; then
  echo "❌ Could not get ngrok URL. Is ngrok running with the API exposed on localhost:4040?"
  exit 1
fi

echo "✅ Current ngrok URL: $NGROK_URL"

# Update .env file with new NGROK= value
if [ -f "$ENV_FILE" ]; then
  if grep -q "^NGROK=" "$ENV_FILE"; then
    sed -i.bak "s|^NGROK=.*|NGROK=$NGROK_URL|" "$ENV_FILE"
  else
    echo "NGROK=$NGROK_URL" >> "$ENV_FILE"
  fi
  echo "✅ Updated .env file at $ENV_FILE"
else
  echo "❌ .env file not found at $ENV_FILE"
  exit 1
fi

# Restart Docker containers with the new env
echo "♻️ Restarting containers using $COMPOSE_FILE..."
docker-compose -f "$COMPOSE_FILE" down
docker-compose -f "$COMPOSE_FILE" up -d --build

echo "✅ Docker containers restarted with updated NGROK URL"