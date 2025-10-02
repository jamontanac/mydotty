-- Enhanced Floating Terminal Plugin
-- Supports multiple terminals and detects existing terminal buffers
-- State Management
-- Each terminal maintains its own state:
--
-- Buffer ID: Tracks the terminal buffer
--
-- Window ID: Tracks the floating window
--
-- Job ID: Tracks the terminal process for command sending
--
-- Persistence: Automatically handles buffer restoration
local floatingTerm = {}

-- State to track multiple terminal instances
floatingTerm.terminals = {}
floatingTerm.current_terminal = 1
floatingTerm.max_terminals = 2 -- Support up to 2 terminals

-- Initialize terminal state if not exists
function floatingTerm.init_terminal(term_id)
    if not floatingTerm.terminals[term_id] then
        floatingTerm.terminals[term_id] = {
            floating = { buf = -1, win = -1 },
            job_id = 0,
        }
    end
end

-- Find existing terminal buffer by checking buftype
function floatingTerm.find_existing_terminal_buffer()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == 'terminal' then
            local buf_name = vim.api.nvim_buf_get_name(bufnr)
            -- Check if it's a terminal buffer and if it's not already assigned
            if buf_name:match '^term://' then
                -- Check if this buffer is already tracked
                local is_tracked = false
                for _, terminal in pairs(floatingTerm.terminals) do
                    if terminal.floating.buf == bufnr then
                        is_tracked = true
                        break
                    end
                end
                if not is_tracked then
                    return bufnr
                end
            end
        end
    end
    return nil
end

function floatingTerm.create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.7)
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
            title = opts.title or ('Terminal ' .. (opts.term_id or 1)),
            title_pos = 'center',
        }),
    }
end

-- Toggle specific terminal by ID
function floatingTerm.toggle_terminal(term_id)
    term_id = term_id or floatingTerm.current_terminal
    floatingTerm.init_terminal(term_id)

    local terminal = floatingTerm.terminals[term_id]

    -- If terminal window is open, hide it
    if vim.api.nvim_win_is_valid(terminal.floating.win) then
        vim.api.nvim_win_hide(terminal.floating.win)
        terminal.floating.win = -1
        return
    end

    -- Check if we can reuse an existing terminal buffer (for persistence support)
    if not vim.api.nvim_buf_is_valid(terminal.floating.buf) then
        local existing_buf = floatingTerm.find_existing_terminal_buffer()
        if existing_buf then
            terminal.floating.buf = existing_buf
            terminal.job_id = vim.bo[existing_buf].channel
            vim.notify('Reusing existing terminal buffer', vim.log.levels.INFO)
        end
    end

    -- Create floating window
    terminal.floating = floatingTerm.create_floating_window {
        buf = terminal.floating.buf,
        term_id = term_id,
        title = 'Terminal ' .. term_id,
    }

    -- Create terminal if buffer doesn't contain one
    if vim.bo[terminal.floating.buf].buftype ~= 'terminal' then
        vim.cmd.terminal()
        terminal.job_id = vim.bo[terminal.floating.buf].channel
    end

    floatingTerm.current_terminal = term_id
end

-- Cycle between terminals
function floatingTerm.cycle_terminals()
    -- Hide current terminal
    local current = floatingTerm.terminals[floatingTerm.current_terminal]
    if current and vim.api.nvim_win_is_valid(current.floating.win) then
        vim.api.nvim_win_hide(current.floating.win)
        current.floating.win = -1
    end

    -- Move to next terminal
    floatingTerm.current_terminal = floatingTerm.current_terminal % floatingTerm.max_terminals + 1
    floatingTerm.toggle_terminal(floatingTerm.current_terminal)
end

-- Send command to specific terminal
function floatingTerm.send_command(cmd, term_id)
    term_id = term_id or floatingTerm.current_terminal
    floatingTerm.init_terminal(term_id)

    local terminal = floatingTerm.terminals[term_id]

    -- Validation checks
    if not terminal.job_id then
        vim.notify('No terminal job ID available for terminal ' .. term_id, vim.log.levels.ERROR)
        return
    end

    if not vim.api.nvim_win_is_valid(terminal.floating.win) then
        vim.notify('Terminal ' .. term_id .. ' not active', vim.log.levels.WARN)
        return
    end

    local buf = terminal.floating.buf
    if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal') then
        vim.notify('Invalid terminal buffer for terminal ' .. term_id, vim.log.levels.ERROR)
        return
    end

    vim.fn.chansend(terminal.job_id, { cmd .. '\r' })
end
-- Send to current terminal
-- require('plugins.floating-terminal').send_command('ls -la')

-- Send to specific terminal
-- require('plugins.floating-terminal').send_command('npm run build', 2)

-- List all active terminals
function floatingTerm.list_terminals()
    local active_terminals = {}
    for term_id, terminal in pairs(floatingTerm.terminals) do
        if vim.api.nvim_buf_is_valid(terminal.floating.buf) then
            table.insert(active_terminals, {
                id = term_id,
                is_open = vim.api.nvim_win_is_valid(terminal.floating.win),
                buffer = terminal.floating.buf,
            })
        end
    end
    return active_terminals
end

-- Terminal autocommands and keymaps setup
vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'open terminal in nvim',
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

-- Terminal mode escape
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Commands for multiple terminals
vim.api.nvim_create_user_command('FloatTerminal', function()
    floatingTerm.toggle_terminal()
end, {})

vim.api.nvim_create_user_command('FloatTerminal1', function()
    floatingTerm.toggle_terminal(1)
end, {})

vim.api.nvim_create_user_command('FloatTerminal2', function()
    floatingTerm.toggle_terminal(2)
end, {})

-- vim.api.nvim_create_user_command('FloatTerminal3', function()
--     floatingTerm.toggle_terminal(3)
-- end, {})

vim.api.nvim_create_user_command('FloatTerminalCycle', function()
    floatingTerm.cycle_terminals()
end, {})

-- send command example
vim.api.nvim_create_user_command('FloatTerminalSend', function(opts)
    local args = opts.fargs
    if #args < 1 then
        vim.notify('Usage: FloatTerminalSend <command> [terminal_id]', vim.log.levels.INFO)
        return
    end
    local cmd = args[1]
    local term_id = tonumber(args[2]) or nil
    floatingTerm.send_command(cmd, term_id)
end, {
    nargs = '+',
    complete = function(arglead, _, _)
        if arglead:match '^%d+$' then
            return { '1', '2' } -- Add more if you increase max_terminals
        else
            return { 'FloatTerminalSend <command> [terminal_id]' }
        end
    end,
})

-- Key mappings for easy access
vim.keymap.set({ 'n', 't' }, '<leader>tt', function()
    floatingTerm.toggle_terminal()
end, { desc = 'Toggle floating terminal' })
vim.keymap.set({ 'n', 't' }, '<leader>t1', function()
    floatingTerm.toggle_terminal(1)
end, { desc = 'Toggle terminal 1' })
vim.keymap.set({ 'n', 't' }, '<leader>t2', function()
    floatingTerm.toggle_terminal(2)
end, { desc = 'Toggle terminal 2' })
-- vim.keymap.set({ 'n', 't' }, '<leader>t3', function()
--     floatingTerm.toggle_terminal(3)
-- end, { desc = 'Toggle terminal 3' })
vim.keymap.set({ 'n', 't' }, '<leader>tc', function()
    floatingTerm.cycle_terminals()
end, { desc = 'Cycle between terminals' })

return floatingTerm
-- my little plugin
-- Create floating terminal with <leader>tt
-- local floatingTerm = {}
-- floatingTerm.state = { floating = { buf = -1, win = -1 }, job_id = 0 }
--
-- function floatingTerm.create_floating_window(opts)
--     opts = opts or {}
--     local width = opts.width or math.floor(vim.o.columns * 0.6)
--     local height = opts.height or math.floor(vim.o.lines * 0.5)
--     local col = math.floor((vim.o.columns - width) / 2)
--     local row = math.floor((vim.o.lines - height) / 2)
--
--     local buf = vim.api.nvim_buf_is_valid(opts.buf) and opts.buf or vim.api.nvim_create_buf(false, true)
--
--     return {
--         buf = buf,
--         win = vim.api.nvim_open_win(buf, true, {
--             relative = 'editor',
--             width = width,
--             height = height,
--             col = col,
--             row = row,
--             style = 'minimal',
--             border = opts.border or 'rounded',
--         }),
--     }
-- end
--
-- function floatingTerm.toggle_terminal()
--     if vim.api.nvim_win_is_valid(floatingTerm.state.floating.win) then
--         vim.api.nvim_win_hide(floatingTerm.state.floating.win)
--         floatingTerm.state.floating.win = -1
--         return
--     end
--
--     floatingTerm.state.floating = floatingTerm.create_floating_window { buf = floatingTerm.state.floating.buf }
--     if vim.bo[floatingTerm.state.floating.buf].buftype ~= 'terminal' then
--         vim.cmd.terminal()
--         floatingTerm.state.job_id = vim.bo[floatingTerm.state.floating.buf].channel
--     end
-- end
--
-- function floatingTerm.send_command(cmd)
--     -- Add job_id validation
--     if not floatingTerm.state.job_id then
--         vim.notify('No terminal job ID available', vim.log.levels.ERROR)
--         return
--     end
--
--     if not vim.api.nvim_win_is_valid(floatingTerm.state.floating.win) then
--         vim.notify('Terminal not active', vim.log.levels.WARN)
--         return
--     end
--
--     local buf = floatingTerm.state.floating.buf
--     if not (vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal') then
--         vim.notify('Invalid terminal buffer', vim.log.levels.ERROR)
--         return
--     end
--
--     vim.fn.chansend(floatingTerm.state.job_id, { cmd .. '\r' })
-- end
--
-- vim.api.nvim_create_autocmd('TermOpen', {
--     desc = 'open terminal in nvim',
--     group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
--     callback = function()
--         vim.opt.number = false
--         vim.opt.relativenumber = false
--     end,
-- })
-- -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- -- or just use <C-\><C-n> to exit terminal mode
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- -- Command and key mappings
-- vim.api.nvim_create_user_command('FloatTerminal', floatingTerm.toggle_terminal, {})
-- vim.keymap.set({ 'n', 't' }, '<leader>tt', floatingTerm.toggle_terminal, { desc = 'Toggle floating terminal' })
