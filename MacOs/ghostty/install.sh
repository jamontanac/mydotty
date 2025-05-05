
#use homebrew to install ghostty
echo "Installing Ghostty..."
# check if ghostty is already installed with cask or it is already in Applications
if [ -d "/Applications/Ghostty.app" ]; then
    echo "Ghostty is already installed in Applications."
elif brew list --cask | grep -q ghostty; then
    echo "Ghostty is already installed."
else
    brew install --cask ghostty
    echo "Ghostty installed successfully."
fi

echo "Setting up Ghostty..."
# Set up Ghostty
# make sure the folder ~/.config/ghostty exists
mkdir -p ~/.config/ghostty
# copy the config file to ~/.config/ghostty
cp ./ghostty/config ~/.config/ghostty/
echo "Ghostty set up successfully and ready to use."