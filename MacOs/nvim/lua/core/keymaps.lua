-- set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable the spacebar key default mapping
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- For conciseness
local opts = { noremap = true, silent = true }

-- Set easy exit keymaps
vim.keymap.set("i", "jk", "<Esc>", opts)
vim.keymap.set("i", "jj", "<Esc>", opts)

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Delete single character without yanking it to the default register
vim.keymap.set("n", "x", '"_x', opts)
-- Quit file
vim.keymap.set("n", "<C-q>", "<cmd>q<CR>", opts, { desc = "Quit Neovim" })
-- Save file
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", opts, { desc = "Save current buffer" })
-- Save file and quit
vim.keymap.set("n", "<leader>x", "<cmd>bd<CR>", opts, { desc = "Close current buffer" })

-- Keybinds to make split navigation easier.
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", opts, { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", opts, { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", opts, { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", opts, { desc = "Move focus to the upper window" })

-- Scroll and center
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })

-- Find and center
vim.keymap.set("n", "n", "nzzzv", opts, { desc = "Find next and center" })
vim.keymap.set("n", "N", "Nzzzv", opts, { desc = "Find previous and center" })

-- Move selected text up and down
vim.keymap.set("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv", opts, { desc = "Move selected text down" })
vim.keymap.set("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv", opts, { desc = "Move selected text up" })

-- Move lines up and down in normal mode
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", opts, { desc = "Move current line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", opts, { desc = "Move current line up" })

-- Resize with arrows
vim.keymap.set("n", "<Up>", "<cmd>resize -2<CR>", opts, { desc = "Resize window up" })
vim.keymap.set("n", "<Down>", "<cmd>resize +2<CR>", opts, { desc = "Resize window down" })
vim.keymap.set("n", "<Left>", "<cmd>vertical resize -2<CR>", opts, { desc = "Resize window left" })
vim.keymap.set("n", "<Right>", "<cmd>vertical resize +2<CR>", opts, { desc = "Resize window right" })

--Tabs
-- vim.keymap.set('n', '<leader>to', '<cmd>tabnew<CR>', opts, { desc = 'Open new tab' })
-- vim.keymap.set('n', '<leader>tx', '<cmd>tabclose<CR>', opts, { desc = 'Close current tab' })
-- vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<CR>', opts, { desc = 'Go to next tab' })
-- vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<CR>', opts, { desc = 'Go to previous tab' })

-- Toggle line wrapping
vim.keymap.set("n", "<leader>tlw", function()
  vim.wo.wrap = not vim.wo.wrap
  print("Line wrapping is now " .. (vim.wo.wrap and "enabled" or "disabled"))
end, opts, { desc = "Toggle line wrapping" })

-- --  stay in indent mode after indenting
-- vim.keymap.set('v', '<', '<gv', opts, { desc = 'Decrease indent and stay in visual mode' })
-- vim.keymap.set('v', '>', '>gv', opts, { desc = 'Increase indent and stay in visual mode' })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to next diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostic [E]rror message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
