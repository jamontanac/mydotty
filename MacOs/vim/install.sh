# This create a folder structure for vim and install vim-plug
# .vim/
#  ├── autoload/
#  ├── backup/
#  ├── colors/
#  └── plugged/
mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
brew install fzf
brew install ripgrep

echo -e '
# set ripgrep for fzf as default 
if type rg &>/dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  #export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
  export FZF_DEFAULT_OPTS='-m --height 40% --layout=reverse --border'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
' | tee -a ~/.zshrc ~/.bash_profile > /dev/null
/bin/zsh -c "source ~/.zshrc"
