-- my little plugin
-- Create floating terminal with <leader>tt
local floatingTerm = {}
floatingTerm.state = { floating = { buf = -1, win = -1 }, job_id = 0 }

function floatingTerm.create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.6)
    local height = opts.height or math.floor(vim.o.lines * 0.5)
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

-- -- Create floating terminal with <leader>tt
-- local state = {
--     floating = { buf = -1, win = -1 },
-- }
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
--     if not vim.api.nvim_win_is_valid(state.floating.win) then
--         -- If the floating window is not valid, create a new one
--         state.floating = create_floating_window { buf = state.floating.buf }
--         if vim.bo[state.floating.buf].buftype ~= 'terminal' then
--             vim.cmd.terminal()
--         end
--     else
--         vim.api.nvim_win_hide(state.floating.win)
--     end
-- end
-- vim.api.nvim_create_user_command('FloatTerminal', toggle_terminal, { desc = 'Open a floating terminal' })
-- vim.keymap.set({ 'n', 't' }, '<leader>tt', toggle_terminal, { desc = 'Toggle floating terminal' })
