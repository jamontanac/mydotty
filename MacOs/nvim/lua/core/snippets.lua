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
-- YAML filetype: indentation and folding
-- vim.api.nvim_create_autocmd('FileType', {
--     group = filetype_vim,
--     pattern = 'yaml',
--     command = 'setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab foldmethod=indent',
-- })
-- --
-- -- JSON filetype: indentation and marker folding with custom markers
-- vim.api.nvim_create_autocmd('FileType', {
--     group = filetype_vim,
--     pattern = 'json',
--     command = 'setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab foldmethod=indent',
-- })
-- Store terminal buffer id

-- -- Bottom terminal for pre-commit checks
-- local state_bottom = {
--     buf = -1,
--     win = -1,
-- }
--
-- local function create_bottom_terminal()
--     -- Check if terminal window is already open
--     if vim.api.nvim_win_is_valid(state_bottom.win) then
--         -- Focus the existing terminal window
--         vim.api.nvim_set_current_win(state_bottom.win)
--         return
--     end
--
--     -- Create horizontal split at the bottom
--     vim.cmd('botright split')
--
--     -- Set window height to 7 lines
--     vim.api.nvim_win_set_height(0, 7)
--
--     -- Check if we have a valid terminal buffer
--     if vim.api.nvim_buf_is_valid(state_bottom.buf) and vim.bo[state_bottom.buf].buftype == 'terminal' then
--         -- Use existing terminal buffer
--         vim.api.nvim_win_set_buf(0, state_bottom.buf)
--     else
--         -- Create new terminal
--         vim.cmd.terminal()
--         state_bottom.buf = vim.api.nvim_get_current_buf()
--     end
--
--     -- Store the window ID
--     state_bottom.win = vim.api.nvim_get_current_win()
-- end
--
-- local function run_precommit_check()
--     -- Create or focus bottom terminal
--     create_bottom_terminal()
--
--     -- Send the pre-commit command to the terminal
--     local job_id = vim.bo[state_bottom.buf].channel
--     if job_id then
--         vim.api.nvim_chan_send(job_id, 'poetry run pre-commit run -a\r')
--     end
-- end
--
-- -- Create user command and keymap for pre-commit check
-- vim.api.nvim_create_user_command('PreCommitCheck', run_precommit_check, { desc = 'Run pre-commit checks in bottom terminal' })
-- vim.keymap.set('n', '<leader>ch', run_precommit_check, { desc = 'Run pre-commit checks' })
-- local terminal_bufnr = nil
-- vim.keymap.set('n', '<space>tt', function()
--     if terminal_bufnr and vim.fn.bufexists(terminal_bufnr) == 1 then
--         -- Terminal buffer exists, check if it's visible
--         local win_id = vim.fn.bufwinid(terminal_bufnr)
--         if win_id ~= -1 then
--             -- Terminal is visible, hide it
--             vim.api.nvim_win_hide(win_id)
--         else
--             -- Terminal exists but is hidden, show it
--             vim.cmd.vsplit()
--             vim.cmd.wincmd 'J'
--             -- Use pcall to safely try switching to the buffer
--             local success = pcall(vim.cmd, 'buffer ' .. terminal_bufnr)
--             if success then
--                 vim.api.nvim_win_set_height(0, 7)
--             else
--                 -- Buffer doesn't actually exist, reset and create new one
--                 terminal_bufnr = nil
--                 vim.cmd.term()
--                 vim.cmd.wincmd 'J'
--                 vim.api.nvim_win_set_height(0, 7)
--                 terminal_bufnr = vim.api.nvim_get_current_buf()
--             end
--         end
--     else
--         -- No terminal exists, create new one
--         vim.cmd.vnew()
--         vim.cmd.term()
--         vim.cmd.wincmd 'J'
--         vim.api.nvim_win_set_height(0, 7)
--         -- Store the new terminal buffer id
--         terminal_bufnr = vim.api.nvim_get_current_buf()
--     end
-- end)
--
--

-- my little plugin
local floatingTerm = {}
floatingTerm.state = { floating = { buf = -1, win = -1 }, job_id = 0 }

function floatingTerm.create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.6)
    local height = opts.height or math.floor(vim.o.lines * 0.6)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local buf = vim.api.nvim_buf_is_valid(opts.buf) and opts.buf or vim.api.nvim_create_buf(false, true)

    return {
        buf = buf,
        win = vim.api.nvim_open_win(buf, true, {
            relative = 'editor',
            width = width,
            height = height,
            col = col,
            row = row,
            style = 'minimal',
            border = opts.border or 'rounded',
        }),
    }
end

function floatingTerm.toggle_terminal()
    if vim.api.nvim_win_is_valid(floatingTerm.state.floating.win) then
        vim.api.nvim_win_hide(floatingTerm.state.floating.win)
        floatingTerm.state.floating.win = -1
        return
    end

    floatingTerm.state.floating = floatingTerm.create_floating_window { buf = floatingTerm.state.floating.buf }
    if vim.bo[floatingTerm.state.floating.buf].buftype ~= 'terminal' then
        vim.cmd.terminal()
        floatingTerm.state.job_id = vim.bo[floatingTerm.state.floating.buf].channel
    end
end

function floatingTerm.send_command(cmd)
    -- Add job_id validation
    if not floatingTerm.state.job_id then
        vim.notify('No terminal job ID available', vim.log.levels.ERROR)
        return
    end

    if not vim.api.nvim_win_is_valid(floatingTerm.state.floating.win) then
        vim.notify('Terminal not active', vim.log.levels.WARN)
        return
    end

    local buf = floatingTerm.state.floating.buf
    if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal') then
        vim.notify('Invalid terminal buffer', vim.log.levels.ERROR)
        return
    end

    vim.fn.chansend(floatingTerm.state.job_id, { cmd .. '\r' })
end

vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'open terminal in nvim',
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Command and key mappings
vim.api.nvim_create_user_command('FloatTerminal', floatingTerm.toggle_terminal, {})
vim.keymap.set({ 'n', 't' }, '<leader>tt', floatingTerm.toggle_terminal, { desc = 'Toggle floating terminal' })
-- vim.keymap.set({ 'n', 't' }, '<leader>rpc', function()
--     floatingTerm.send_command 'poetry run pre-commit run -a'
-- end, { desc = 'Run poetry python' })
-- vim.keymap.set({ 'n', 't' }, '<leader>rc', function()
--     floatingTerm.send_command 'pre-commit run -a'
-- end, { desc = 'Run poetry python' })
-- vim.keymap.set({ 'n', 't' }, '<leader>rr', function()
--     vim.fn.chansend(floatingTerm.state.job_id, { '' })
-- end, { desc = 'run recent command in terminal' })
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
