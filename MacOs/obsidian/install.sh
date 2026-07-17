#!/usr/bin/env bash
set -euo pipefail

if brew list --cask obsidian &>/dev/null; then
    echo "Obsidian already installed"
else
    echo "Installing Obsidian..."
    brew install --cask obsidian
fi