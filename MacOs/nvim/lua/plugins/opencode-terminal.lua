-- Enhanced Opencode Terminal Plugin
-- Dedicated terminal management for opencode AI assistant

local OpencodeTerminal = {}

-- State for opencode terminal
OpencodeTerminal.state = {
    buf = -1,
    win = -1,
    job_id = 0,
    is_opencode_running = false,
    is_window_visible = false, -- Track visibility explicitly
}

-- Create floating window with opencode-specific styling
function OpencodeTerminal.create_floating_window(buf)
    buf = buf or vim.api.nvim_create_buf(false, true)

    local width = math.floor(vim.o.columns * 0.85)
    local height = math.floor(vim.o.lines * 0.80)
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        width = width,
        height = height,
        col = col,
        row = row,
        style = 'minimal',
        border = 'rounded',
        title = '🤖 OpenCode AI Assistant',
        title_pos = 'center',
    })

    return { buf = buf, win = win }
end

-- Initialize terminal - create actual terminal buffer
function OpencodeTerminal.init_terminal()
    -- If buffer exists and is valid, reuse it
    if vim.api.nvim_buf_is_valid(OpencodeTerminal.state.buf) then
        -- Check if it's already a terminal
        if vim.bo[OpencodeTerminal.state.buf].buftype == 'terminal' then
            return true
        end
    end

    -- Create new buffer for terminal
    OpencodeTerminal.state.buf = vim.api.nvim_create_buf(false, true)

    -- We need to open it in a window first to create the terminal
    local old_win = vim.api.nvim_get_current_win()
    local floating = OpencodeTerminal.create_floating_window(OpencodeTerminal.state.buf)
    OpencodeTerminal.state.win = floating.win
    OpencodeTerminal.state.is_window_visible = true

    -- Now create the terminal
    vim.cmd.terminal()

    -- Get the job ID
    OpencodeTerminal.state.job_id = vim.bo[OpencodeTerminal.state.buf].channel

    -- Return to previous window
    vim.api.nvim_set_current_win(old_win)

    return true
end

-- Toggle opencode terminal
function OpencodeTerminal.toggle()
    -- If window is visible, hide it
    if OpencodeTerminal.state.is_window_visible then
        if vim.api.nvim_win_is_valid(OpencodeTerminal.state.win) then
            vim.api.nvim_win_hide(OpencodeTerminal.state.win)
        end
        OpencodeTerminal.state.win = -1
        OpencodeTerminal.state.is_window_visible = false
        return
    end

    -- Initialize terminal if needed
    if OpencodeTerminal.state.job_id == 0 then
        OpencodeTerminal.init_terminal()
        return
    end

    -- Show the window (if buffer still exists)
    if vim.api.nvim_buf_is_valid(OpencodeTerminal.state.buf) then
        local floating = OpencodeTerminal.create_floating_window(OpencodeTerminal.state.buf)
        OpencodeTerminal.state.win = floating.win
        OpencodeTerminal.state.is_window_visible = true

        -- Auto-launch opencode on first toggle
        if not OpencodeTerminal.state.is_opencode_running then
            vim.defer_fn(function()
                if OpencodeTerminal.state.job_id ~= 0 then
                    vim.fn.chansend(OpencodeTerminal.state.job_id, { 'opencode\r' })
                    OpencodeTerminal.state.is_opencode_running = true
                    vim.notify('Starting OpenCode...', vim.log.levels.INFO)
                end
            end, 200)
        end
    end
end

-- Ensure opencode is ready (called by opencode.nvim)
function OpencodeTerminal.ensure_opencode()
    -- If opencode is already running and visible, just return
    if OpencodeTerminal.state.is_opencode_running and OpencodeTerminal.state.is_window_visible then
        return
    end

    -- If terminal doesn't exist, initialize it
    if OpencodeTerminal.state.job_id == 0 then
        OpencodeTerminal.init_terminal()
    elseif not OpencodeTerminal.state.is_window_visible then
        -- Just show the window if terminal exists
        OpencodeTerminal.toggle()
    end
end

-- Terminal autocommands
vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'Configure opencode terminal',
    pattern = 'term://*',
    group = vim.api.nvim_create_augroup('opencode-terminal', { clear = true }),
    callback = function()
        -- Only apply to our opencode buffer
        if vim.api.nvim_buf_get_number(0) == OpencodeTerminal.state.buf then
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.signcolumn = 'no'
        end
    end,
})

-- Detect when terminal closes
vim.api.nvim_create_autocmd('TermClose', {
    desc = 'Handle opencode terminal close',
    pattern = 'term://*',
    group = vim.api.nvim_create_augroup('opencode-terminal-close', { clear = true }),
    callback = function()
        if vim.api.nvim_buf_get_number(0) == OpencodeTerminal.state.buf then
            OpencodeTerminal.state.is_opencode_running = false
            OpencodeTerminal.state.job_id = 0
            OpencodeTerminal.state.is_window_visible = false
            vim.notify('OpenCode session ended', vim.log.levels.INFO)
        end
    end,
})

-- Commands
vim.api.nvim_create_user_command('OpencodeToggle', function()
    OpencodeTerminal.toggle()
end, {})

-- Keymaps
vim.keymap.set({ 'n', 't' }, '<leader>ot', function()
    OpencodeTerminal.toggle()
end, { desc = 'Toggle OpenCode terminal' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

return OpencodeTerminal
