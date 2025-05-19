
if brew list fd &>/dev/null; then
    echo "fd already installed"
else
    echo "Installing fd..."
    brew install fd
fi
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
if brew list tmux &>/dev/null; then
    echo "tmux already installed"
else
    echo "Installing tmux..."
    brew install tmux
fi
if brew list jq &>/dev/null; then
    echo "jq already installed"
else
    echo "Installing jq..."
    brew install jq
fi
if brew list ripgrep &>/dev/null; then
    echo "ripgrep already installed"
else
    echo "Installing ripgrep..."
    brew install ripgrep
fi
if brew list bat &>/dev/null; then
    echo "bat already installed"
else
    echo "Installing bat..."
    brew install bat
fi
if brew list eza &>/dev/null; then
    echo "eza already installed"
else
    echo "Installing eza..."
    brew install eza
fi


cat << 'EOF' | tee -a ~/.zshrc ~/.bash_profile > /dev/null
#Makes the default directory listing more readable and visually informative.
alias ls='eza --color=always --group-directories-first --icons'
# Detailed listing of all files with group info, directories at the top
alias la='eza --la --group --octal-permissions --group-directories-first --icons'
#Extremely detailed listing with all metadata, color scales, icons, and Git status
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'

#Tree view of the directory up to two levels deep, with colors and icons
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
#List only hidden files in the current directory
alias l.="eza -a | grep -E '^\.'"
EOF
cat << 'EOF' | tee -a ~/.zshrc ~/.bash_profile > /dev/null
if type rg &>/dev/null; then
    # set ripgrep for fzf as default 
    export FZF_DEFAULT_COMMAND="rg --files"
fi
# Style fzf
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --tmux center \
    --border=rounded \ 
    --border-label=🔍👀🔎 --border-label-pos=0 --preview-window=border-rounded \
    --padding=1 --margin=1 --prompt=» --marker=🔦 \
    --pointer=✸ --separator=📚 --scrollbar=| --layout=reverse-list \
    --info=right --style full --bind 'focus:transform-header:file --brief {}'"
EOF