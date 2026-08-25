#!/usr/bin/env bash
set -euo pipefail

if brew list lazygit &>/dev/null; then
    echo "LazyGit already installed"
else
    echo "Installing LazyGit..."
    brew install lazygit
    echo "LazyGit installed successfully."
fi

if brew list git-delta &>/dev/null; then
    echo "Git Delta already installed"
else
    echo "Installing Git Delta..."
    brew install git-delta
    echo "Git Delta installed successfully."
fi
