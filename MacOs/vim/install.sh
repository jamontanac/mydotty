# This create a folder structure for vim and install vim-plug
# .vim/
#  ├── autoload/
#  ├── backup/
#  ├── colors/
#  └── plugged/
# check if these folders exist and create them if not

mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# check with brew if each package is installed and install it if not

# copy the vimrc file to ~/.vimrc
cp vim/.vimrc ~/.vimrc
# set ripgrep for fzf as default 
/bin/zsh -c "source ~/.vimrc"
