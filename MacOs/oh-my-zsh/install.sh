#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── 1. Install oh-my-zsh ──────────────────────────────────────────────────────
echo "Installing oh-my-zsh..."
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "oh-my-zsh is already installed. Skipping."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# ── 2. Symlink custom plugins ─────────────────────────────────────────────────
echo "Linking custom plugins..."
for plugin in "$SCRIPT_DIR/plugins/"*; do
  [[ -e "$plugin" ]] || continue
  plugin_file="$(basename "$plugin")"
  plugin_name="${plugin_file%%.*}"
  plugin_dir="$HOME/.oh-my-zsh/custom/plugins/$plugin_name"

  mkdir -p "$plugin_dir"
  ln -sfn "$plugin" "$plugin_dir/$plugin_file"
  echo "  Linked $plugin_dir/$plugin_file -> $plugin"
done

# ── 3. Symlink .zshrc ─────────────────────────────────────────────────────────
echo "Linking .zshrc..."
ln -sfn "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
echo "  Linked $HOME/.zshrc -> $SCRIPT_DIR/.zshrc"

echo "Done. Edit files in the repo and changes will reflect immediately."