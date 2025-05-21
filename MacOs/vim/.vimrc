"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               
"               
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║     
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║     
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"               
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""   
"------------------------------------------------------------------------------

" Basic Settings ---------------------------------------------------------------- {{{
" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Sensible backspace
set backspace=indent,eol,start


" When opening a window put it right or below the current one
set splitright
set splitbelow



" Speed up syntax highlight
"syntax sync minlines=10000
"set redrawtime=10000

" Mouse Support
set mouse=a
" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Set the numbering and relative numbering
set number
set relativenumber

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
" set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Do not wrap lines. Allow long lines to extend as far as the line goes.
" set nowrap

" Incremental search (show matches as you type)
set incsearch

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" Show matching words during a search.
set showmatch

" Highlight search results
set hlsearch

" Set the commands to save in history default number is 20.
" set history=1000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" " Fix delay when exiting insert mode
set ttimeoutlen=10
" Improve terminal title
set title
let &titlestring = "vim: %F %r%m"

" }}}



" PLUGINS ---------------------------------------------------------------- {{{

" Plugin code goes here.
call plug#begin('~/.vim/plugged')

    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-abolish'
    Plug 'tpope/vim-repeat'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-vinegar'
    Plug 'junegunn/vim-easy-align'
    Plug 'rose-pine/vim'
    " Plug 'dense-analysis/ale'
    Plug 'preservim/vim-indent-guides'
    Plug 'mbbill/undotree'
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'lukhio/vim-mapping-conflicts' # this does not work
    "Plug 'preservim/nerdtree'

call plug#end()

""Get the style of the undo tree
let g:undotree_WindowLayout = 2
""Map de undo tree
nnoremap <Leader><C-U> :UndotreeToggle<CR>
" enable the indend guides
let g:indent_guides_enable_on_vim_startup = 1
" finding Files
"nnoremap <silent> <C-f> :Files<CR>
""" Finding in Files
nnoremap <silent> <Leader>f :Rg<CR>
""Search between buffers
"nnoremap <silent> <Leader>b :Buffers<CR>
""Search in lines between buffers
nnoremap <silent> <Leader><C-l> :BLines<CR>
"" Search between marks
"nnoremap <silent> <Leader>' :Marks<CR>
""Search between Commits
"nnoremap <silent> <Leader>g :Commits<CR>
""Search for help
" nnoremap <silent> <Leader><C-h>:Helptags<CR>
""Search between command history, it allows to rerun comands
"nnoremap <silent> <Leader>hh :History<CR>
""list all the history commands done by :
nnoremap <silent> <Leader>h. :History:<CR>
"""search in the history of searches
nnoremap <silent> <Leader>h/ :History/<CR>



" setup grepprg so that the :grep Vim command uses ripgrep.
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

"Search and Replace in Multiple Files
""Modern text editors like VSCode makes it very easy to search and replace a string across multiple files. In this section, I will show you two different methods to easily do that in Vim.
"
"The first method is to replace all matching phrases in your project. You will need to use :grep. If you want to replace all instances of 'pizza' with 'donut', here's what you do:
"
":grep 'pizza'
":cfdo %s/pizza/donut/g | update
"Let's break down the commands:
"
":grep pizza uses ripgrep to search for all instances of 'pizza' (by the way, this would still work even if you didn't reassign grepprg to use ripgrep. You would have to do :grep 'pizza' . -R instead of :grep 'pizza').
":cfdo executes any command you pass to all files in your quickfix list. In this case, your command is the substitution command %s/pizza/donut/g. The pipe (|) is a chain operator. The update command saves each file after substitution. I will cover the substitute command in more depth in a later chapter.
"The second method is to search and replace in selected files. With this method, you can manually choose which files you want to perform select-and-replace on. Here is what you do:
"
"Clear your buffers first. It is imperative that your buffer list contains only the files you want to apply the replace on. You can either restart Vim or run :%bd | e# command (%bd deletes all the buffers and e# opens the file you were just on).
"Run :Files.
"Select all files you want to perform search-and-replace on. To select multiple files, use <Tab> / <Shift-Tab>. This is only possible if you have the multiple flag (-m) in FZF_DEFAULT_OPTS.
"Run :bufdo %s/pizza/donut/g | update. The command :bufdo %s/pizza/donut/g | update looks similar to the earlier :cfdo %s/pizza/donut/g | update command. The difference is instead of substituting all quickfix entries (:cfdo), you are substituting all buffer entries (:bufdo).
"" }}}


" MAPPINGS --------------------------------------------------------------- {{{

" Mappings code goes here.
" Set <Space> as the leader key
let mapleader = " "
" Set easy exit          
inoremap jk <esc>
inoremap kj <esc>
"turn off search highlight by using esc esc
nnoremap <esc><esc> :nohlsearch<CR>

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz
"" Map the F5 key to run a Python script inside Vim.
" I map F5 to a chain of commands here.
" :w saves the file.
" <CR> (carriage return) is like pressing the enter key.
" !clear runs the external clear screen command.
" !python3 % executes the current file with Python.
" nnoremap <f5> :w <CR>:!clear <CR>:!python3 % <CR>

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

"copy and paste from clipboard
if has('clipboard')
  noremap gy "+y
  noremap gp "+p
  noremap <leader>gp o<esc>"+p
endif
" exiting current buffer
nnoremap <leader>q :bdelete<CR>
map <leader>n :bnext<CR>
map <leader>p :bprevious<CR>
" mapping the backspace to delete as expected
inoremap <Char-0x07F> <BS>
nnoremap <Char-0x07F> <BS>
" }}}

" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
augroup END

" If Vim version is equal to or greater than 7.3 enable undofile.
" This allows you to undo changes to a file even after saving it.
if version >= 703
    set undodir=~/.vim/backup
    set undofile
    set undoreload=100
    " Temp files directory
    " Specifies where backup files (filename~) should be stored
    set backupdir=~/.vim/backup/
    " Specifies where swap files (.filename.swp) should be stored
    set directory=~/.vim/backup/
endif

" You can split a window into sections by typing `:split` or `:vsplit`.
" Display cursorline and cursorcolumn ONLY in active window.
" AUGROUP CURSOR_OFF
"     autocmd!
"     autocmd WinLeave * set nocursorline nocursorcolumn
"     " autocmd WinEnter * set cursorline cursorcolumn
"     autocmd WinEnter * set cursorline
" augroup END

" Better color support
if (has("termguicolors"))
  set termguicolors
endif

" set guifont='0xProto Nerd Font'\ Regular\ 14
" Option 2: Use let syntax to avoid escaping spaces
let &guifont = "0xProto Nerd Font Regular 16"

" If GUI version of Vim is running set these options.
if has('gui_running')

    " Set the background tone.
    set background=dark

    " Set the color scheme.
    colorscheme molokai

    " Set a custom font you have installed on your computer.
    " Syntax: set guifont=<font_name>\ <font_weight>\ <size>

    " Display more of the file by default.
    " Hide the toolbar.
    set guioptions-=T

    " Hide the the left-side scroll bar.
    set guioptions-=L

    " Hide the the right-side scroll bar.
    set guioptions-=r

    " Hide the the menu bar.
    set guioptions-=m

    " Hide the the bottom scroll bar.
    set guioptions-=b

    " Map the F4 key to toggle the menu, toolbar, and scroll bar.
    " <Bar> is the pipe character.
    " <CR> is the enter key.
    nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
        \set guioptions-=mTr<Bar>
        \else<Bar>
        \set guioptions+=mTr<Bar>
        \endif<CR>
else
    " Terminal-specific settings
   
    " Enable 256 colors in the terminal
    set t_Co=256
   
    " Set the background tone for terminal
    set background=dark
   
    " Try to use the same colorscheme as GUI if available
    colorscheme rosepine
    " try
    "     " colorscheme molokai
    "     colorscheme rosepine
    " catch /^Vim\%((\a\+)\)\=:E185/
    "     " Fallback colorschemes if molokai is not available
    "     try 
    "         colorscheme desert
    "     catch
    "         colorscheme default
    "     endtry
    " endtry
   
   
endif
" In Vim, Change the shape of cursor in insert mode
" for VTE compatible terminals
if !has('nvim')
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
endif

"Set a function to highlight what we yank
" function! FlashYankedText()
"   let g:idTemporaryHighlight = matchadd('IncSearch', ".\\%>'\\[\\_.*\\%<']..")
"   call timer_start(250, 'DeleteTemporaryMatch')
" endfunction

" function! DeleteTemporaryMatch(timerId)
"   call matchdelete(g:idTemporaryHighlight)
" endfunction

" augroup highlightYankedText
"   autocmd!
"   autocmd TextYankPost * call FlashYankedText()
" augroup END


" }}}


" STATUS LINE ------------------------------------------------------------ {{{


" Status bar code goes here.
" Rosé Pine colors for terminal (cterm)
highlight User1 ctermbg=235  ctermfg=108  cterm=bold  " Pine (green) on muted background
highlight User2 ctermbg=none ctermfg=168  cterm=bold  " Love (pink/red)
highlight User3 ctermbg=none ctermfg=216  cterm=bold  " Gold (peach)
highlight User4 ctermbg=none ctermfg=109  cterm=bold  " Foam (cyan)
highlight User5 ctermbg=none ctermfg=139              " Iris (lavender)

set statusline=
" Left side: File info (Pine)
set statusline+=%1*\ %F\                              " Full file path (User1: Pine)
set statusline+=%2*%M%3*%Y%4*%R%*                     " Flags: Modified, Filetype, Read-only (Users 2-4)
" Right side: Position/encoding (Foam/Iris)
set statusline+=%=%5*\|%{&fileencoding?&fileencoding:&encoding}\|\ ASCII:\ %b\ \ Hex:\ 0x%B\      " ASCII/Hex (User5: Iris)
set statusline+=%4*◼︎\ Row:\ %l\ Col:\ %c\ [%p%%]     " Position (User4: Foam)
" " Enable status bar
" " Clear status line when vimrc is reloaded.
" set statusline=
" " Status line left side.
" set statusline+=\ %F\ %M\ %Y\ %R
" " Use a divider to separate the left side from the right side.
" set statusline+=%=
" " Status line right side.
" set statusline+=\ Ascii:\ %b\ Hex:\ 0x%B\ Row:\ %l\ Col:\ %c\ [%p%%]
set laststatus=2
" set statusline=%f\ %m%r%h%w\ %=Ln\ %l:\ Col\ %c\ %p%%\ %b\ %y\ 
" set statusline=%f\ %m%r%h%w\ %=%{&ff}\ Ln\ %l:\ Col\ %c\ %p%%

"%f - Shows the relative path to the file being edited
"
"\ - Adds a space for separation
"
"%m - Shows a modified flag [+] when the buffer has been changed
"
"%r - Shows a read-only flag [RO] when the file is read-only
"
"%h - Shows a help flag [Help] when in a help buffer
"
"%w - Shows a preview flag [Preview] when in a preview window
"
"\ - Another space
"
"%= - Right-aligns everything that follows this
"
"%{&ff} - Shows the file format (unix, dos, mac)
"
"\ Ln\ %l:\ Col\ %c\ - Shows "Ln" followed by the current line number, then "Col" followed by the column number
"
"%p%% - Shows the position as a percentage through the file
"set statusline=
"set statusline+=%=
"set statusline+=\ %r
"set statusline+=\%m
"set statusline+=\%{zoom#statusline()}
"set statusline+=\ %l:%c
"set statusline+=\ %p%%
"set statusline+=\ %y
"if exists('$TMUX')
""  set statusline+=\ \[\%{fnamemodify(getcwd(),':t')}\]
""endif
""set statusline+=\ 

" }}}




" Netrw ------------------------------------------------------------ {{{
" let g:netrw_liststyle = 3
""No banner
"let g:netrw_banner = 0
"" How files are opened
"" 1 - open files in a new horizontal split
"" 2 - open files in a new vertical split
"" 3 - open files in a new tab
"" 4 - open in previous window
"let g:netrw_browse_split = 1
"" Set the width of the window to 25%
let g:netrw_winsize = 25
" use gh to toggle the hidden files
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
"}}}

