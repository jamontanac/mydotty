# installing pyenv
echo "Installing pyenv..."
brew install pyenv pyenv-virtualenv
echo "pyenv installed successfully."
echo $(pyenv --version)
echo 'eval "$(pyenv init --path)"' >> ~/.zshrc
/bin/zsh -c "source ~/.zshrc"