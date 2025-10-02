vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank { higroup = 'IncSearch', timeout = 150 }
    end,
})

-- makes * and # work on visual mode too.
vim.api.nvim_exec(
    [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]],
    false
)

local filetype_vim = vim.api.nvim_create_augroup('filetype_vim', { clear = true })
--
-- Vim filetype: foldmethod=marker
vim.api.nvim_create_autocmd('FileType', {
    group = filetype_vim,
    pattern = 'vim',
    command = 'setlocal foldmethod=marker',
})
-- For JSON and YAML
vim.api.nvim_create_autocmd('FileType', {
    group = filetype_vim,
    pattern = { 'json', 'yaml' },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
        vim.opt_local.foldmethod = 'indent'
    end,
})
-- 4. Autocmd to set filetype for .pyx
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
--     pattern = { '*.pyx', '*.pxd', '*.pxi' },
--     callback = function()
--         vim.bo.filetype = 'cython'
--     end,
-- })
-- Treat .pyx files as Python so Pyright attaches
-- vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
--     pattern = '*.pyx',
--     callback = function()
--         vim.bo.filetype = 'python'
--     end,
-- })
--

vim.filetype.add {
    extension = {
        h = 'cpp',
        tpp = 'cpp',
        cu = 'cuda',
    },
}
-- Create floating terminal with <leader>tt
-- local state_floating = {
--     floating = { buf = -1, win = -1 },
-- }
-- local job_id = 0
-- local function create_floating_window(opts)
--     opts = opts or {}
--     local width = opts.width or math.floor(vim.o.columns * 0.8)
--     local height = opts.height or math.floor(vim.o.lines * 0.8)
--
--     -- calculate the position to center the window
--     local col = math.floor((vim.o.columns - width) / 2)
--     local row = math.floor((vim.o.lines - height) / 2)
--
--     -- create a new buffer
--     local buf = nil
--     if vim.api.nvim_buf_is_valid(opts.buf) then
--         -- If a buffer is provided, use it
--         buf = opts.buf
--     else
--         -- Otherwise, create a new scratch buffer
--         buf = vim.api.nvim_create_buf(false, true) -- no file, just scratch buffer
--     end
--
--     -- define window configuration
--     local win_opts = {
--         relative = 'editor',
--         width = width,
--         height = height,
--         col = col,
--         row = row,
--         style = 'minimal',
--         border = 'rounded',
--     }
--
--     -- Create the floating window
--     local win = vim.api.nvim_open_win(buf, true, win_opts)
--
--     return { buf = buf, win = win }
-- end
--
-- local toggle_terminal = function()
--     if not vim.api.nvim_win_is_valid(state_floating.floating.win) then
--         -- If the floating window is not valid, create a new one
--         state_floating.floating = create_floating_window { buf = state_floating.floating.buf }
--         if vim.bo[state_floating.floating.buf].buftype ~= 'terminal' then
--             vim.cmd.terminal()
--         end
--     else
--         vim.api.nvim_win_hide(state_floating.floating.win)
--     end
--     job_id = vim.bo[state_floating.floating.buf].channel
-- end
--
-- vim.api.nvim_create_user_command('FloatTerminal', toggle_terminal, { desc = 'Open a floating terminal' })
-- vim.keymap.set({ 'n', 't' }, '<leader>tt', toggle_terminal, { desc = 'Toggle floating terminal' })
-- vim.keymap.set({ 'n', 't' }, '<leader><C-c>', function()
--     -- Check if terminal is active
--     if not vim.api.nvim_win_is_valid(state_floating.floating.win) then
--         print 'Floating terminal not active'
--         return
--     end
--     -- send command to the terminal
--     vim.fn.chan_send(job_id, { "ls .\r'" })
-- end, { desc = 'Run precommit hooks' })

-- Setting up the env variables from the .env file
local function load_env_file(filepath)
    local file = io.open(filepath, 'r')
    if not file then
        vim.notify('.env file not found at ' .. filepath, vim.log.levels.WARN)
        return
    end

    for line in file:lines() do
        -- Ignore comments and blank lines
        if not line:match '^%s*#' and line:match '=' then
            local key, value = line:match '^%s*([%w_]+)%s*=%s*(.*)%s*$'
            if key and value then
                vim.env[key] = value
            end
        end
    end
    file:close()
    vim.notify('.env loaded from ' .. filepath)
end

-- Call this function in your config to load ~/.env
load_env_file(vim.fn.expand '~/.env')
