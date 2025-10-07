return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        completions = {
            blink = { enabled = true },
            lsp = { enabled = true },
        },
        -- Add this configuration
        overrides = {
            buftype = {
                nofile = {
                    render_modes = true, -- Enable rendering in all modes
                    padding = { highlight = 'NormalFloat' },
                    sign = { enabled = false },
                },
            },
        },
    },
    config = function(_, opts)
        require('render-markdown').setup(opts)

        -- If you use the mini.nvim suite, you can enable the markdown renderer
        -- by adding this line to your init.lua:
        -- require('mini.markdown').setup()
        --
        -- If you use standalone mini plugins, you can enable the markdown renderer
        -- by adding this line to your init.lua:
        -- require('mini.markdown').setup({ render = true })
    end,
}
