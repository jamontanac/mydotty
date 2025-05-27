#installing oh-my-zsh

echo "Installing oh-my-zsh..."
#check if oh-my-zsh is already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "oh-my-zsh is already installed. Skipping installation."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
#add the plugins to the plugins folder
echo "Adding plugins to"
# list all the plugins in the plugins folder and create a folder with the same name
for plugin in ./oh-my-zsh/plugins/*; do

  plugin_name_file=$(basename "$plugin")
  #split the file name and get the first part
  plugin_name="${plugin_name_file%%.*}"
  echo "Creating folder for $plugin_name"
  mkdir -p ~/.oh-my-zsh/custom/plugins/"$plugin_name"
  cp ./oh-my-zsh/plugins/"$plugin_name_file" ~/.oh-my-zsh/custom/plugins/"$plugin_name"/
done
#copy the zshrc file to the home directory
echo "Copying zshrc file to home directory..."
cp ./oh-my-zsh/.zshrc ~/
# # apply the changes
echo "Applying changes..."
/bin/zsh -c "source ~/.zshrc"