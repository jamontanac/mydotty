#!/usr/bin/env bash
set -euo pipefail

PIXI_BIN="$HOME/.pixi/bin/pixi"

if [[ -x "$PIXI_BIN" ]]; then
    echo "Pixi already installed"
else
    curl -fsSL https://pixi.sh/install.sh | PIXI_NO_PATH_UPDATE=1 sh
fi

"$PIXI_BIN" self-update
"$PIXI_BIN" --version

echo "Pixi installed. Reload your shell or run: source ~/.zshrc"