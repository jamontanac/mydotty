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
if brew list node &>/dev/null; then
    echo "node already installed"
else
    echo "Installing node..."
    brew install node
fi
# copy the vimrc file to ~/.vimrc
cp vim/.vimrc ~/.vimrc
/bin/zsh -c "source ~/.vimrc"

# install vim plugins
# vim -c 'PlugInstall|q|q'
vim +PlugInstall +qall
# install coc.nvim
vim +CocInstall coc-json coc-clangd coc-docker coc-yaml @yaegassy/coc-pylsp coc-sh coc-sql coc-toml coc-yank @yaegassy/coc-ruff coc-lua +qall