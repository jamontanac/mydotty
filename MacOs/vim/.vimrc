"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""               "{{{}}}
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

" Set shift width to 2 spaces.
set shiftwidth=2

" Set tab width to 2 columns.
set tabstop=2

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
" set nobackup

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=12
set sidescrolloff=5

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

" " Enable auto completion menu after pressing TAB.
set wildmenu

" " Make wildmenu behave like similar to Bash completion.
" set wildmode=list:longest
" set wildmode=list:full
set wildmode=list:longest,list:full

set wildchar=<Tab> 
" set wildchar=<Tab>  wildmode=full

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" " Fix delay when exiting insert mode
set ttimeoutlen=10
" Improve terminal title
set title
let &titlestring = "VIM: %F %r%m"
"Set the hidden option (:set hidden) so any buffer can be hidden (keeping its changes) without first writing the buffer to a file. This affects all commands and all buffers.
set hidden


set confirm


set autowrite
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
    Plug 'junegunn/vim-peekaboo'
    Plug 'rose-pine/vim'
    " Plug 'dense-analysis/ale'
    " Plug 'preservim/vim-indent-guides'
    Plug 'Yggdroot/indentLine'
    Plug 'mbbill/undotree'
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
    Plug 'jmattaa/regedit.vim'
    " Plug 'lukhio/vim-mapping-conflicts' # this does not work
    "Plug 'preservim/nerdtree'

call plug#end()

" let g:airline_theme='base16-spacemacs'
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
" Set Space as the leader key
nnoremap <SPACE> <Nop>
let mapleader = " " 
" Set easy exit          
inoremap jj <esc>
inoremap jk <esc>
"turn off search highlight by using esc esc
nnoremap <leader><esc><esc> :nohlsearch<CR>

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzzzv
nnoremap N Nzzzv
"" Map the F5 key to run a Python script inside Vim.
" I map F5 to a chain of commands here.
" :w saves the file.
" <CR> (carriage return) is like pressing the enter key.
" !clear runs the external clear screen command.
" !python3 % executes the current file with Python.
" nnoremap <f5> :w <CR>:!clear <CR>:!python3 % <CR>

" Adding a way to use search groups
cnoremap <F3> \(.*\)

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
"copy and paste from clipboard
if has('clipboard')
  onoremap gy "+y
  noremap gp "+p
  noremap <leader>gp o<esc>"+p
endif
" exiting current buffer
nnoremap <leader>x :bdelete<CR>
" exiting vim with warnings
nnoremap <C-q> :q<CR>
" map <leader><TAB> :bnext<CR>
" map <leader> :bprevious<CR>
" mapping the backspace to delete as expected
" inoremap <Char-0x07F> <BS>
" nnoremap <Char-0x07F> <BS>
function! s:VSetSearch()
  let temp = @@
  norm! gvy
  let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
  call histadd('/', substitute(@/, '[?/]', '\="\\%d".char2nr(submatch(0))', 'g'))
  let @@ = temp
endfunction

vnoremap * :<C-u>call <SID>VSetSearch()<CR>/<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>?<CR>



" }}}

" plugins config -------------------------------------------------------- {{{
"
" mapping the plugings
"

"  configuration for the indentLine plugin 
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:vim_json_conceal = 0
let g:markdown_syntax_conceal = 0
" let g:indentLine_char = '⦙'
" let g:indentLine_setColors = 0
let g:indentLine_enabled = 0

nnoremap <silent> <leader>toggle<Tab> :IndentLinesToggle<CR>

""Get the style of the undo tree
let g:undotree_WindowLayout = 1
""Map de undo tree
nnoremap <F4> :UndotreeToggle<CR>
" enable the indend guides
" let g:indent_guides_enable_on_vim_startup = 1
" finding Files
"nnoremap <silent> <C-f> :Files<CR>
""" Finding in Files
nnoremap <silent> <leader><leader>f :Rg<CR>
""Search between buffers
nnoremap <silent> <leader><leader>b :Buffers<CR>
""Search in lines between buffers
nnoremap <silent> <leader><C-f> :BLines<CR>
"" Search between marks
""Search for help
nnoremap <silent> <leader><C-h> :Helptags<CR>
""Search between command history, it allows to rerun comands
"nnoremap <silent> <Leader>hh :History<CR>
""list all the history commands done by :
nnoremap <silent> <leader><leader>h. :History:<CR>
"""search in the history of searches
nnoremap <silent> <leader><leader>h/ :History/<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
"
" }}}



" LSP config ------------------------------------------------------------ {{{
"
"" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=400
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
" inoremap <silent><expr> <TAB>
"       \ coc#pum#visible() ? coc#pum#next(1) :
"       \ CheckBackspace() ? "\<Tab>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" " Make <CR> to accept selected completion item or notify coc.nvim to format
" " <C-g>u breaks current undo
" " What Does <C-g>u Do?
" " <C-g>u (Control + g, then u) is a special Vim command used in insert mode.

" " It tells Vim: "End the current undo block here. Start a new one from now on."

" " So, when you press Enter and the mapping includes <C-g>u, Vim will treat everything you typed before pressing Enter as one undo block, and everything after as a new block.
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" " What Is This Used For?
" " This function is often used in mappings for autocompletion plugins (like coc.nvim) to decide if pressing Tab should insert a tab/indent, or trigger completion.

" " If at the start of the line or after whitespace:
" " Tab should insert a tab/indent.

" " Otherwise:
" " Tab might trigger completion or snippet expansion.
" function! CheckBackspace() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Use <c-space> to trigger completion
" if has('nvim')
"   inoremap <silent><expr> <c-space> coc#refresh()
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif

" " Use `[g` and `]g` to navigate diagnostics
" " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
" nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
" nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" " GoTo code navigation
" nmap <silent><nowait> gd <Plug>(coc-definition)
" nmap <silent><nowait> gy <Plug>(coc-type-definition)
" nmap <silent><nowait> gi <Plug>(coc-implementation)
" nmap <silent><nowait> gr <Plug>(coc-references)

" " Use K to show documentation in preview window
" nnoremap <silent> K :call ShowDocumentation()<CR>

" " function! ShowDocumentation()
" "   if CocAction('hasProvider', 'hover')
" "     call CocActionAsync('doHover')
" "   else
" "     call feedkeys('K', 'in')
" "   endif
" " endfunction

" " " Highlight the symbol and its references when holding the cursor
" " autocmd CursorHold * silent call CocActionAsync('highlight')

" " " Symbol renaming
" " nmap <leader>rn <Plug>(coc-rename)

" " nnoremap <silent> <space>y  :<C-u>CocList -A --normal yank<cr>
" " " Formatting selected code
" " xmap <leader>f  <Plug>(coc-format-selected)
" " nmap <leader>f  <Plug>(coc-format-selected)

" " augroup mygroup
" "   autocmd!
" "   " Setup formatexpr specified filetype(s)
" "   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
" " augroup end

" " " Applying code actions to the selected code block
" " " Example: `<leader>aap` for current paragraph
" " xmap <leader>a  <Plug>(coc-codeaction-selected)
" " nmap <leader>a  <Plug>(coc-codeaction-selected)

" " " Remap keys for applying code actions at the cursor position
" " nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" " " Remap keys for apply code actions affect whole buffer
" " nmap <leader>as  <Plug>(coc-codeaction-source)
" " " Apply the most preferred quickfix action to fix diagnostic on the current line
" " nmap <leader>qf  <Plug>(coc-fix-current)

" " " Remap keys for applying refactor code actions
" " nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
" " xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
" " nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" " Run the Code Lens action on the current line
" nmap <leader>cl  <Plug>(coc-codelens-action)

" " Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" " Remap <C-f> and <C-b> to scroll float windows/popups
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


" }}}



" VIMSCRIPT -------------------------------------------------------------- {{{

" This will enable code folding.
" Use the marker method of folding.
augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
        autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab foldmethod=indent
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
    hi Normal guibg=NONE ctermbg=NONE
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



function! FlashYankedText()
    " Skip if triggered by 'd' (DeleteWithHighlight) or in insert mode/special buffers
    if exists('v:event') && get(v:event, 'operator', '') ==# 'd'
        return
    endif
    if mode() =~ '[iR]' || &buftype != ''
        return
    endif
    let l:start = getpos("'[")
    let l:end = getpos("']")
    if l:start[1] == l:end[1]
        let g:idTemporaryHighlight = matchaddpos('IncSearch', [[l:start[1], l:start[2], l:end[2] - l:start[2] + 1]])
    else
        let g:idTemporaryHighlight = matchadd('IncSearch', '\%>' . (l:start[1]-1) . 'l\%<' . (l:end[1]+1) . 'l')
    endif
    call timer_start(10, 'DeleteTemporaryMatch')
endfunction

function! DeleteTemporaryMatch(timerId)
  " Check if the highlight ID exists and is valid
  if exists('g:idTemporaryHighlight') && type(g:idTemporaryHighlight) == v:t_number
    silent! call matchdelete(g:idTemporaryHighlight)
    unlet! g:idTemporaryHighlight
  endif
endfunction

augroup highlightYankedText
  autocmd!
  autocmd TextYankPost * call FlashYankedText()
augroup END
" let g:highlightedyank_highlight_duration = 5

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'luna'
" let g:airline_solarized_bg='dark'
" Show full file path in section 'a'
" let g:airline_section_a = '%F'

" Section 'b': Modified flag, filetype, read-only
" let g:airline_section_b = '%{&modified?"[+]":""} %{&filetype} %{&readonly?"[RO]":""}'

" Section 'c': coc.nvim status
" let g:airline_section_c = '%{coc#status()}%{get(b:,"coc_current_function","")}'

" Section 'x': encoding, ASCII, Hex
let g:airline_section_y = '%{&fileencoding?&fileencoding:&encoding} ASCII:%b Hex:0x%B'

" Section 'y': Position
" let g:airline_section_y = '%l:%c [%p%%]'


"

" Section 'z': (leave default or customize further)
" Status bar code goes here.
" Rosé Pine colors for terminal (cterm)
" highlight User1 ctermbg=235  ctermfg=108  cterm=bold  " Pine (green) on muted background
" highlight User2 ctermbg=none ctermfg=168  cterm=bold  " Love (pink/red)
" highlight User3 ctermbg=none ctermfg=216  cterm=bold  " Gold (peach)
" highlight User4 ctermbg=none ctermfg=109  cterm=bold  " Foam (cyan)
" highlight User5 ctermbg=none ctermfg=139              " Iris (lavender)

" " --- Statusline ---
" set statusline=
" set statusline+=%1*\ %F\                              " Full file path (User1: Pine)
" set statusline+=%2*%M%3*%Y%4*%R%*                     " Flags: Modified, Filetype, Read-only (Users 2-4)
" set statusline+=%4*%{coc#status()}%{get(b:,'coc_current_function','')} " coc.nvim status/function
" set statusline+=%=                                    " Right align
" set statusline+=%5*\|%{&fileencoding?&fileencoding:&encoding}\|\ ASCII:\ %b\ \ Hex:\ 0x%B\      " ASCII/Hex (User5: Iris)
" set statusline+=%4*◼︎\ Row:\ %l\ Col:\ %c\ [%p%%]     " Position (User4: Foam)

" set laststatus=2

" autocmd User CocStatusChange redrawstatus

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
"
"

