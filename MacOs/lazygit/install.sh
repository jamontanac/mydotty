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

LAZYGIT_CONFIG_DIR="$HOME/Library/Application Support/lazygit"
LAZYGIT_CONFIG_FILE="$LAZYGIT_CONFIG_DIR/config.yml"
DELTA_PAGER_LINE="        - pager: delta --dark --paging=never --syntax-theme base16-256 --diff-so-fancy --side-by-side --line-numbers"

mkdir -p "$LAZYGIT_CONFIG_DIR"

if ! grep -Fq "$DELTA_PAGER_LINE" "$LAZYGIT_CONFIG_FILE" 2>/dev/null; then
    cat >> "$LAZYGIT_CONFIG_FILE" <<'EOF'

git:
    pagers:
        - pager: delta --dark --paging=never --syntax-theme base16-256 --diff-so-fancy --side-by-side --line-numbers
EOF
fi
