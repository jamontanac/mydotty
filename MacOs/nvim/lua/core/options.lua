-- Set Neovim options
vim.o.backspace = 'indent,eol,start' -- sensible backspace
-- when opening a window put it right below the current one
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.mouse = 'a' -- enable the mouse
vim.cmd 'filetype plugin indent on' -- Adding the filedetection
vim.cmd 'syntax on' -- turn syntax highlight
vim.wo.number = true -- Make line numbers default
vim.wo.relativenumber = true -- Set relative numbered lines
vim.wo.cursorline = true
vim.o.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.o.tabstop = 2 -- Number of spaces that a <Tab> counts for while editing
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.showtabline = 2 -- Always show the tabline
vim.o.list = true -- Show whitespace characters
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Set characters for whitespace
vim.opt.listchars = { tab = '|¦┆', trail = '·', nbsp = '␣' } -- Set characters for whitespace
vim.o.smartindent = true -- Smart autoindenting on new lines
vim.o.breakindent = true -- Enable break indent
vim.o.wrap = false -- Disable line wrap
vim.o.scrolloff = 12 -- Minimal number of screen lines to keep above and below the cursor
vim.o.sidescrolloff = 5 -- Minimal number of screen columns to keep left and right of the cursor
vim.o.incsearch = true -- Enable incremental search
vim.o.hlsearch = true -- Highlight search results
vim.o.ignorecase = true -- Ignore case in search patterns
vim.o.smartcase = true -- Override 'ignorecase' if the search pattern contains upper case characters
vim.o.showcmd = true -- Show (partial) command in the last line of the screen
vim.o.cmdheight = 1 -- Height of the command line
vim.o.showmode = false -- Don't show mode since we have a statusline
vim.o.showmatch = true -- Show matching brackets
vim.o.wildmenu = true -- Enable wildmenu
vim.o.wildmode = 'list:longest,list:full' -- Command-line completion mode
vim.o.wildignore = '*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx'
vim.o.wildignorecase = true -- Ignore case in wildmenu
-- vim.o.ttimeoutlen = 10 -- Time to wait for a mapped sequence to complete
vim.o.title = true -- Set the terminal title
vim.o.titlestring = 'NVIM - %F [%{&filetype}]' -- Set the terminal title string
vim.o.hidden = true -- Allow switching to another buffer even if the current one has unsaved changes
vim.o.confirm = true -- Confirm before overwriting a file
vim.o.swapfile = false -- Disable swap files
vim.o.fileencoding = 'utf-8' -- Set file encoding to UTF-8
vim.opt.runtimepath:remove '~/.vim/' -- Remove the default runtime path for Vim in case vim is still in use
vim.o.signcolumn = 'yes' -- Keep signcolumn on by default
vim.o.updatetime = 250 -- Decrease update time
vim.o.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.o.autowrite = true
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
end)
-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

local backup_dir = vim.fn.expand '~/.config/nvim/backup'
-- Create the backup directory if it doesn't exist
if not vim.fn.isdirectory(backup_dir) then
    vim.fn.mkdir(backup_dir, 'p')
end
-- set undo, backup, and swap directories
vim.o.undodir = backup_dir
vim.o.backupdir = backup_dir
vim.o.directory = backup_dir
-- set undo files
vim.o.undofile = true -- Enable persistent undo
vim.o.backup = true -- Disable backup files
vim.opt.undoreload = 10000
