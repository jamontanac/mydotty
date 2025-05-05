#installing oh-my-zsh
echo "Installing oh-my-zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#add the plugins to the plugins folder
echo "Adding plugins to"
cp oh-my-zsh/plugins/* ~/.oh-my-zsh/custom/plugins/
#copy the zshrc file to the home directory
echo "Copying zshrc file to home directory..."
cp oh-my-zsh/.zshrc ~/
#appling the changes
echo "Applying changes..."
source ~/.zshrc