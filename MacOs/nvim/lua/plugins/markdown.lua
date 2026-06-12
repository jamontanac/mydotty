-- return {
--     'OXY2DEV/markview.nvim',
--     lazy = false,

--     dependencies = {
--         'nvim-treesitter/nvim-treesitter',
--         -- Completion for `blink.cmp`
--         'saghen/blink.cmp',
--     },
--     opts = {
--         preview = {
--             enable = true,
--             enable_hybrid_mode = true,
--             filetypes = { 'markdown', 'quarto', 'rmd' },
--             modes = { 'n', 'no', 'c', 'i' },
--             hybrid_modes = { 'i' },
--         },
--         markdown = {
--             enable = true,
--         },
--         markdown_inline = {
--             enable = true,
--         },
--         latex = {
--             enable = true,
--             blocks = {
--                 enable = true,
--                 text = ' LaTeX ',
--             },
--             inlines = {
--                 enable = true,
--             },
--             commands = {
--                 enable = true,
--             },
--             escapes = {
--                 enable = true,
--             },
--             parenthesis = {
--                 enable = true,
--             },
--             fonts = {
--                 enable = true,
--             },
--             subscripts = {
--                 enable = true,
--             },
--             superscripts = {
--                 enable = true,
--             },
--             symbols = {
--                 enable = true,
--             },
--             texts = {
--                 enable = true,
--             },
--         },
--     },
-- };
return {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown' },
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
        latex = {
            enabled = true,
            converter = { 'latex2text', 'utftex', },
        },
    },
    -- keys = {
    --     {
    --         '<leader>te',
    --         function()
    --             require('render-markdown').buf_toggle()
    --         end,
    --         desc = 'Toggle markdown equation rendering',
    --     },
    -- },
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
