#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../common/installer.sh"

install_logical_packages vim git nodejs npm ripgrep fd fzf curl
ensure_fd_command

VIM_ROOT="$HOME/.vim"
for directory in autoload backup colors plugged; do
  mkdir -p "$VIM_ROOT/$directory"
done

VIM_PLUG_PATH="$VIM_ROOT/autoload/plug.vim"
if [[ ! -f "$VIM_PLUG_PATH" ]]; then
  action_log 'Installing vim-plug...'
  curl -fLo "$VIM_PLUG_PATH" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
  action_log 'vim-plug already installed.'
fi

VIMRC="$(get_shared_config_path 'vim/.vimrc')"
action_log 'Installing Vim plugins...'
vim -u "$VIMRC" -n -es '+PlugInstall --sync' '+qa'

COPILOT_DIRECTORY="$VIM_ROOT/pack/github/start/copilot.vim"
if [[ ! -d "$COPILOT_DIRECTORY" ]]; then
  mkdir -p "$(dirname "$COPILOT_DIRECTORY")"
  action_log 'Installing copilot.vim...'
  git clone --depth=1 https://github.com/github/copilot.vim.git "$COPILOT_DIRECTORY"
else
  action_log 'copilot.vim already installed.'
fi

bash "$LINUX_DIR/dev-links/install.sh" install
action_log 'Vim setup is complete.'
