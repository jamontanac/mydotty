# checking if lazygit is already installed
if brew list lazygit &>/dev/null; then
    echo "LazyGit already installed"
else
    echo "Installing LazyGit..."
    brew install lazygit
    echo "LazyGit installed successfully."
fi
if brew git-delta &>/dev/null; then
    echo "Git Delta already installed"
else
    echo "Installing Git Delta..."
    brew install git-delta
    echo "Git Delta installed successfully."
fi
#writing a yaml file with the config for the pager of delta
mkdir -p .config/lazygit
echo -e '
git: 
    paging:
        colorArg: always
        pager: delta --dark --paging=never --syntax-theme base16-256 --diff-so-fancy (or -s for split)
' >> .config/lazygit/config.yml
