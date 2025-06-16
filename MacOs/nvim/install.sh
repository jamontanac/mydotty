# check if nvim is installed
if brew list onefetch &>/dev/null; then
    echo "onefetch already installed"
else
    echo "Installing onefetch..."
    brew install onefetch
fi
if brew list neovim &>/dev/null; then
    echo "neovim already installed"
else
    echo "Installing neovim..."
    brew install neovim
fi
