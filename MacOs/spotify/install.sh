#!/usr/bin/env bash
set -euo pipefail

if brew list --cask spotify &>/dev/null; then
    echo "Spotify already installed"
else
    echo "Installing Spotify..."
    brew install --cask spotify
fi