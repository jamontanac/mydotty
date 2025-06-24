-- Create floating terminal with <leader>tt
local state = {
    floating = { buf = -1, win = -1 },
}
local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    -- calculate the position to center the window
    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    -- create a new buffer
    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        -- If a buffer is provided, use it
        buf = opts.buf
    else
        -- Otherwise, create a new scratch buffer
        buf = vim.api.nvim_create_buf(false, true) -- no file, just scratch buffer
    end

    -- define window configuration
    local win_opts = {
        relative = 'editor',
        width = width,
        height = height,
        col = col,
        row = row,
        style = 'minimal',
        border = 'rounded',
    }

    -- Create the floating window
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    return { buf = buf, win = win }
end

local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        -- If the floating window is not valid, create a new one
        state.floating = create_floating_window { buf = state.floating.buf }
        if vim.bo[state.floating.buf].buftype ~= 'terminal' then
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end
vim.api.nvim_create_user_command('FloatTerminal', toggle_terminal, { desc = 'Open a floating terminal' })
vim.keymap.set({ 'n', 't' }, '<leader>tt', toggle_terminal, { desc = 'Toggle floating terminal' })
