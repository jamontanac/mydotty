#!/usr/bin/env bash
set -euo pipefail

if command -v uv &>/dev/null; then
	echo "uv already installed"
else
	curl -LsSf https://astral.sh/uv/install.sh | sh
fi

if [[ -f "$HOME/.local/bin/env" ]]; then
	# shellcheck disable=SC1090
	source "$HOME/.local/bin/env"
fi

if command -v uv &>/dev/null; then
	uv self update
fi

echo "Reload your shell or run: source ~/.zshrc"
