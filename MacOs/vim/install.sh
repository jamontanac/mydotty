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

if brew list fzf &>/dev/null; then
    echo "fzf already installed"
else
    echo "Installing fzf..."
    brew install fzf
    echo -e '
        # fzf setup for completion
        source <(fzf --zsh)
    ' >> ~/.zshrc
    echo -e '
        # fzf setup for completion
        eval <(fzf --bash)
    ' >> ~/.bash_profile
fi 
if brew list ripgrep &>/dev/null; then
    echo "ripgrep already installed"
else
    echo "Installing ripgrep..."
    brew install ripgrep
fi
if brew list tree &>/dev/null; then
    echo "tree already installed"
else
    echo "Installing tree..."
    brew install tree
fi
if brew list fd &>/dev/null; then
    echo "fd already installed"
else
    echo "Installing fd..."
    brew install fd
fi
if brew list bat &>/dev/null; then
    echo "bat already installed"
else
    echo "Installing bat..."
    brew install bat
fi

# set ripgrep for fzf as default 
cat << 'EOF' | tee -a ~/.zshrc ~/.bash_profile > /dev/null
if type rg &>/dev/null; then
    # set ripgrep for fzf as default 
    export FZF_DEFAULT_COMMAND="rg --files"
    # Style fzf
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --height 80% \
    --border=rounded \
    --border-label=🔍👀🔎 --border-label-pos=0 --preview-window=border-rounded \
    --padding=1 --margin=1 --prompt=» --marker=🔦 \
    --pointer=✸ --separator=📚 --scrollbar=| --layout=reverse-list \
    --info=right" --style full
fi
EOF
/bin/zsh -c "source ~/.zshrc"
