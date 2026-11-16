-- set leader keys
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the spacebar key default mapping
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- Set easy exit keymaps
vim.keymap.set('i', 'jk', '<Esc>', opts)
vim.keymap.set('i', 'jj', '<Esc>', opts)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
-- Delete single character without yanking it to the default register
-- vim.keymap.set("n", "x", '"_x', opts)
-- Quit file
vim.keymap.set('n', '<C-q>', '<cmd>q<CR>', { silent = true, desc = 'Quit Neovim' })
-- Save file
-- vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', { silent = true, desc = 'Save current buffer' })
-- Close the buffer but keep the window/split layout (asks to save if modified).
-- Terminals, special buffers and floats keep plain :bd: with 'confirm' it asks before
-- killing a running job and closes the float (snacks would kill it silently).
vim.keymap.set('n', '<leader>x', function()
    if vim.bo.buftype ~= '' or vim.api.nvim_win_get_config(0).relative ~= '' then
        vim.cmd 'bd'
    else
        require('snacks').bufdelete()
    end
end, { desc = 'Close current buffer (keep window)' })
vim.keymap.set('n', '<leader>c', '<C-W>c', { silent = true, desc = 'Close current window' })

-- Keybinds to make split navigation easier.
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { silent = true, desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { silent = true, desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { silent = true, desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { silent = true, desc = 'Move focus to the upper window' })

-- Scroll and center
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', { silent = true, desc = 'Find next and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { silent = true, desc = 'Find previous and center' })

-- Move selected text up and down
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { silent = true, desc = 'Move selected text down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { silent = true, desc = 'Move selected text up' })

-- Move lines up and down in normal mode
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', { silent = true, desc = 'Move current line down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', { silent = true, desc = 'Move current line up' })

-- Resize with arrows
vim.keymap.set('n', '<Up>', '<cmd>resize -2<CR>', { silent = true, desc = 'Resize window up' })
vim.keymap.set('n', '<Down>', '<cmd>resize +2<CR>', { silent = true, desc = 'Resize window down' })
vim.keymap.set('n', '<Left>', '<cmd>vertical resize -2<CR>', { silent = true, desc = 'Resize window left' })
vim.keymap.set('n', '<Right>', '<cmd>vertical resize +2<CR>', { silent = true, desc = 'Resize window right' })

--Tabs
-- vim.keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', { silent = true, desc = 'Open new tab' })
-- vim.keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', { silent = true, desc = 'Close current tab' })
-- vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<CR>', { silent = true, desc = 'Go to next tab' })
-- vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<CR>', { silent = true, desc = 'Go to previous tab' })

-- Toggle line wrapping
vim.keymap.set('n', '<leader>tlw', function()
    vim.wo.wrap = not vim.wo.wrap
    print('Line wrapping is now ' .. (vim.wo.wrap and 'enabled' or 'disabled'))
end, { silent = true, desc = 'Toggle line wrapping' })

-- --  stay in indent mode after indenting
-- vim.keymap.set('v', '<', '<gv', { silent = true, desc = 'Decrease indent and stay in visual mode' })
-- vim.keymap.set('v', '>', '>gv', { silent = true, desc = 'Increase indent and stay in visual mode' })

-- Diagnostic keymaps
-- [d / ]d are built into Neovim; the float on jump is set in plugins/lsp.lua (diagnostic jump.on_jump)
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open diagnostic [E]rror message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
