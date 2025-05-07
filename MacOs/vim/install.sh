# This create a folder structure for vim and install vim-plug
# .vim/
#  ├── autoload/
#  ├── backup/
#  ├── colors/
#  └── plugged/
mkdir -p ~/.vim ~/.vim/autoload ~/.vim/backup ~/.vim/colors ~/.vim/plugged
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim