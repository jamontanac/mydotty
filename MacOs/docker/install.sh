#!/usr/bin/env bash
set -euo pipefail

#check if docker is installed and install it if not
if brew list --cask docker &>/dev/null; then
    echo "Docker already installed"
else
    echo "Installing Docker..."
    brew install --cask docker
    echo "Docker installed successfully."
fi
echo "Docker version: $(docker --version)"