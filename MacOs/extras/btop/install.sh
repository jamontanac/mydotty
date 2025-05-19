
if brew list btop &>/dev/null; then
    echo "btop already installed"
else
    echo "Installing btop..."
    brew install btop
fi