
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
alias la='eza -la --group --octal-permissions --group-directories-first --icons'
#Extremely detailed listing with all metadata, color scales, icons, and Git status
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'

#Tree view of the directory up to two levels deep, with colors and icons
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
#List only hidden files in the current directory
alias l.="eza -a | grep -E '^\.'"

if type rg &>/dev/null; then
    # set ripgrep for fzf as default 
    export FZF_DEFAULT_COMMAND="rg --files"
fi

# Style fzf
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
    --style full \
    --multi \
    --height 80% \
    --border --padding 1,2 \
    --border-label=🔍👀🔎 --input-label ' Search ' --header-label '📚 File Type 📚' \
    --bind 'focus:+transform-header:file --brief {} || echo \"No file selected\"' \
    --prompt=» --marker=🔦 \
    --pointer=✸"

# Style bat with fuzzy finder
# Use bat with fzf
alias fzfbat="fzf --preview 'bat --style=numbers --color=always --line-range:500 {}'"

# Create a function to search strings in files

# Interactive ripgrep with dynamic search
fzfsearch() {
  local RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  local INITIAL_QUERY="${*:-}"
  fzf --ansi --disabled --query "$INITIAL_QUERY" --multi \
      --bind "start:reload:$RG_PREFIX {q}" \
      --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
      --delimiter : \
      --preview 'bat --color=always {1} --highlight-line {2}' \
      --bind 'enter:become(vim {+1})'
}

# fzfopen [FUZZY PATTERN] - Open the selected file with the default application
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
#   - Use bat for previewing the file
#   - Use open to open the file with the default application (ONLY FOR MACOS)

if [[ "$OSTYPE" == "darwin"* ]]; then
  fzfopen() {
    IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0 --preview="bat --color=always {}"))
    [[ -n "$files" ]] && open "${files[@]}"
  }
else
  fzfopen() {
    IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0 --preview="bat --color=always {}"))
    [[ -n "$files" ]] && xdg-open "${files[@]}"
  }
fi

# fzfhistory [FUZZY PATTERN]- search and rerun a command from the history
# this only works in zsh terminal
# fh - repeat history
fzfhistory() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

EOF
