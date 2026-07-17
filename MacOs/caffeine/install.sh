#!/usr/bin/env bash
set -euo pipefail

if brew list --cask caffeine &>/dev/null; then
    echo "Caffeine already installed"
else
    echo "Installing Caffeine..."
    brew install --cask caffeine
fi