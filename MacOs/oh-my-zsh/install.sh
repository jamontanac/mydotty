#!/usr/bin/env bash
set -euo pipefail

# ── Install oh-my-zsh ─────────────────────────────────────────────────────────
# Symlinking of .zshrc and plugins is handled by dev-links/install.sh
echo "Installing oh-my-zsh..."
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "oh-my-zsh is already installed. Skipping."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "Done. Run 'make dev-links' to symlink .zshrc and custom plugins."