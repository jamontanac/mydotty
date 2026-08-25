#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/installer.sh"

install_logical_packages neovim git nodejs npm ripgrep fd fzf make curl
ensure_neovim_version
ensure_fd_command
install_npm_global_package 'tree-sitter-cli'

bash "$LINUX_DIR/dev-links/install.sh" install

if [[ "${1:-}" == '--extras' ]]; then
  if ! install_logical_packages imagemagick python3 pip; then
    action_log 'Optional ImageMagick and Python packages were not installed. Continuing without them.'
  fi

  python_command=''
  if command -v python3 &>/dev/null; then
    python_command='python3'
  elif command -v python &>/dev/null; then
    python_command='python'
  fi

  if [[ -z "$python_command" ]]; then
    action_log 'Skipping pylatexenc because Python is not available.'
  elif ! "$python_command" -m pip install --user --upgrade pylatexenc; then
    action_log 'pylatexenc was not installed. LaTeX text conversion remains optional.'
  fi

  action_log 'onefetch, rsvg-convert, and utftex remain optional Linux dependencies.'
fi

action_log 'Neovim setup is complete. Start Neovim once to let lazy.nvim and Mason install configured plugins and tools.'
