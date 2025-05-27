# checking if lazygit is already installed
if brew list lazygit &>/dev/null; then
    echo "LazyGit already installed"
else
    echo "Installing LazyGit..."
    brew install lazygit
    echo "LazyGit installed successfully."
fi
