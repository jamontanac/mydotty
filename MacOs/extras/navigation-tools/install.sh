#!/usr/bin/env bash
set -euo pipefail

packages=(fd fzf jq ripgrep bat eza)

for package in "${packages[@]}"; do
    if brew list "$package" &>/dev/null; then
        echo "$package already installed"
    else
        echo "Installing $package..."
        brew install "$package"
    fi
done

echo "Navigation tools installed."
echo "Shell aliases/functions are managed in MacOs/oh-my-zsh/plugins/navigation-tools.plugin.zsh via make dev-links."
