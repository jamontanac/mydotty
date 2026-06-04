#!/usr/bin/env bash
set -euo pipefail

if brew list --cask visual-studio-code &>/dev/null; then
	echo "Visual Studio Code already installed"
else
	brew install --cask visual-studio-code
fi