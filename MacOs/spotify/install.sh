if brew list spotify &>/dev/null; then
    echo "Spotify already installed"
else
    echo "Installing Spotify..."
    brew install --cask spotify
fi