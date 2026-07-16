# Makes the default directory listing more readable and visually informative.
alias ls='eza --color=always --group-directories-first --icons=always'
# Detailed listing of all files with group info, directories at the top.
alias la='eza -la --group --octal-permissions --group-directories-first --icons'
# Extremely detailed listing with metadata, icons, and Git status.
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'

# Tree view of the directory up to two levels deep.
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
# List only hidden files in the current directory.
alias l.="eza -a | grep -E '^\.'"

if command -v rg >/dev/null 2>&1; then
  # Use ripgrep as fzf default source when available.
  export FZF_DEFAULT_COMMAND="rg --files"
fi

if command -v fzf >/dev/null 2>&1; then
  # Enable fzf key bindings and completion for zsh.
  source <(fzf --zsh)
fi

# fzf styling.
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --style full \
  --multi \
  --height 80% \
  --border --padding 1,2 \
  --border-label=🔍👀🔎 --input-label ' Search ' --header-label '📚 File Type 📚' \
  --bind 'focus:+transform-header:file --brief {} || echo \"No file selected\"' \
  --prompt=» --marker=🔦 \
  --pointer=✸"

# Use bat with fzf.
alias fzfbat="fzf --preview 'bat --style=numbers --color=always --line-range:500 {}'"

# Interactive ripgrep with dynamic search.
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

# Open selected files with default system application.
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

# Search and rerun a command from history (zsh-focused).
fzfhistory() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}
