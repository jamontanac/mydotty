local mdmath_enabled_buffers = {}

local function terminal_hint()
    local term = (os.getenv('TERM') or ''):lower()
    local term_program = (os.getenv('TERM_PROGRAM') or ''):lower()

    if term:find('kitty') or term_program == 'ghostty' then
        return
    end

    vim.notify('mdmath.nvim works best in Kitty-compatible terminals (kitty/ghostty).', vim.log.levels.WARN)
end

local function toggle_mdmath()
    local bufnr = vim.api.nvim_get_current_buf()

    if mdmath_enabled_buffers[bufnr] then
        require('mdmath').disable(bufnr)
        mdmath_enabled_buffers[bufnr] = nil
        vim.notify('mdmath disabled for current buffer', vim.log.levels.INFO)
        return
    end

    terminal_hint()
    require('mdmath').enable(bufnr)
    mdmath_enabled_buffers[bufnr] = true
    vim.notify('mdmath enabled for current buffer', vim.log.levels.INFO)
end

return {
    'Thiago4532/mdmath.nvim',
    ft = { 'markdown' },
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    opts = {
        -- Keep mdmath manual for now so it does not auto-run in unsupported terminals.
        filetypes = {},
        foreground = 'Normal',
        anticonceal = true,
        hide_on_insert = true,
        dynamic = true,
        dynamic_scale = 1.0,
        update_interval = 400,
        internal_scale = 1.0,
    },
    keys = {
        {
            '<leader>tm',
            toggle_mdmath,
            ft = 'markdown',
            desc = 'Toggle mdmath rendering',
        },
        {
            '<leader>tr',
            function()
                require('mdmath').clear(0)
            end,
            ft = 'markdown',
            desc = 'Refresh mdmath equations',
        },
    },
    config = function(_, opts)
        require('mdmath').setup(opts)

        vim.api.nvim_create_autocmd('BufWipeout', {
            callback = function(args)
                mdmath_enabled_buffers[args.buf] = nil
            end,
        })

        vim.api.nvim_create_user_command('MdMathToggle', toggle_mdmath, {
            desc = 'Toggle mdmath for current buffer',
        })
    end,
}
