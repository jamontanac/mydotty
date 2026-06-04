
#!/usr/bin/env bash
set -euo pipefail

# Symlinking of ghostty/config is handled by dev-links/install.sh
echo "Installing Ghostty..."
if [[ -d "/Applications/Ghostty.app" ]]; then
    echo "Ghostty is already installed in Applications."
elif brew list --cask | grep -q ghostty; then
    echo "Ghostty is already installed."
else
    brew install --cask ghostty
    echo "Ghostty installed successfully."
fi

echo "Done. Run 'make dev-links' to symlink the Ghostty config."