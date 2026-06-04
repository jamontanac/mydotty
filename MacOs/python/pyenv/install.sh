#!/usr/bin/env bash
set -euo pipefail

echo "Installing pyenv..."
brew install pyenv pyenv-virtualenv
echo "pyenv installed successfully."
pyenv --version

if ! grep -Fq 'eval "$(pyenv init --path)"' "$HOME/.zshrc" 2>/dev/null; then
	echo 'eval "$(pyenv init --path)"' >> "$HOME/.zshrc"
fi

echo "Reload your shell or run: source ~/.zshrc"