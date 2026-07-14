#!/usr/bin/env bash
set -euo pipefail

# Symlinking of .vimrc is handled by dev-links/install.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create vim folder structure
# .vim/
#  ├── autoload/
#  ├── backup/
#  ├── colors/
#  └── plugged/
mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install node (required by coc.nvim)
if brew list node &>/dev/null; then
    echo "node already installed"
else
    echo "Installing node..."
    brew install node
fi

# Install vim plugins using the repository configuration so this does not depend
# on whether dev-links has already created ~/.vimrc.
vim -u "$SCRIPT_DIR/.vimrc" -n -es '+PlugInstall --sync' '+qa'

# Install copilot.vim
if [[ ! -d "$HOME/.vim/pack/github/start/copilot.vim" ]]; then
    git clone --depth=1 https://github.com/github/copilot.vim.git \
      ~/.vim/pack/github/start/copilot.vim
else
    echo "copilot.vim already installed."
fi

echo "Done. Run 'make dev-links' to symlink .vimrc."
