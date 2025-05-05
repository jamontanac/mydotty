
#use homebrew to install ghostty
echo "Installing Ghostty..."
brew install --cask ghostty
echo "Ghostty installed successfully."
echo "Setting up Ghostty..."
# Set up Ghostty
# make sure the folder ~/.config/ghostty exists
mkdir -p ~/.config/ghostty
# copy the config file to ~/.config/ghostty
cp ./ghostty/config ~/.config/ghostty/
echo "Ghostty set up successfully and ready to use."