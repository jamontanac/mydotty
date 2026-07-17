#!/usr/bin/env bash
set -euo pipefail

if brew list --cask docker &>/dev/null; then
    echo "Docker already installed"
else
    echo "Installing Docker..."
    brew install --cask docker
    echo "Docker installed successfully."
fi

if ! command -v docker &>/dev/null; then
    echo "Docker Desktop is installed. Start it once, then reopen your shell to use the docker command." >&2
    exit 1
fi

echo "Docker version: $(docker --version)"

if docker compose version &>/dev/null; then
    docker compose version
    echo "Docker Compose v2 is available."
elif command -v docker-compose &>/dev/null; then
    docker-compose version
    echo "Docker Compose is available."
else
    echo "Installing Docker Compose..."
    brew install docker-compose
    docker-compose version
    echo "Docker Compose is available."
fi