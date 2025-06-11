# check if nvim is installed
if brew list neovim &>/dev/null; then
    echo "neovim already installed"
else
    echo "Installing neovim..."
    brew install neovim
fi
