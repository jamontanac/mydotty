return {
    { 'tpope/vim-surround' },
    { 'tpope/vim-sleuth' },
    { 'tpope/vim-repeat' },
    -- { 'wgurecky/vimSum' },
    -- {
    --     'sk1418/HowMuch',
    --     config = function()
    --         -- Default HowMuch configurations
    --         vim.g.HowMuch_scale = 2 -- decimal places
    --         -- the engine order for auto-calculation
    --         vim.g.HowMuch_auto_engines = { 'bc', 'vim', 'py' }
    --         vim.g.HowMuch_auto_insert = 1 -- auto insert result
    --         -- vim.g.HowMuch_no_mappings = 0 -- use default mappings
    --     end,
    -- },
    { 'norcalli/nvim-colorizer.lua' },
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = { signs = false },
    },
    {
        'jiaoshijie/undotree',
        dependencies = 'nvim-lua/plenary.nvim',
        config = true,
        keys = { -- load the plugin only when using it's keybinding:
            { '<leader>u', "<cmd>lua require('undotree').toggle()<cr>" },
        },
    },
    {
        'junegunn/vim-easy-align',
        keys = {
            -- Normal mode mapping
            { 'ga', '<Plug>(EasyAlign)', mode = 'n', desc = 'EasyAlign (Normal Mode)' },
            -- Visual mode mapping
            { 'ga', '<Plug>(EasyAlign)', mode = 'x', desc = 'EasyAlign (Visual Mode)' },
        },
        config = function()
            -- Define custom delimiters for EasyAlign
            vim.g.easy_align_delimiter = {
                ['|'] = {
                    'align_on_pipe', -- This is a common style for pipes
                    'align_on_pipe_left', -- Align to the left of the pipe
                    'align_on_pipe_right', -- Align to the right of the pipe
                    'align_on_pipe_gap', -- Align based on the gap around the pipe
                    'align_on_pipe_outer', -- Align outer pipes (for table borders)
                    'align_on_pipe_inner', -- Align inner pipes (for column separators)
                },
                -- You can keep existing defaults or add others if you wish
                ['='] = { 'align_on_eq', 'align_on_equal', 'align_on_assign' },
                ['.'] = { 'align_on_dot' },
                -- Add any other delimiters you frequently use
            }
        end,
    },
    -- { 'nvim-mini/mini.align', version = false },
}
