return {
    {
        'nvim-mini/mini.align',
        version = false,
        config = function()
            require('mini.align').setup {
                -- Example custom options for mini.align
                mappings = {
                    start = 'ga', -- Change to your preferred key
                    start_with_preview = 'gA',
                },
                -- Default options controlling alignment process
                options = {
                    split_pattern = '',
                    justify_side = 'left',
                    merge_delimiter = '',
                },
                -- Any other align options here
            }
        end,
    },
    {
        'nvim-mini/mini.surround',
        version = false,
        config = function()
            require('mini.surround').setup {
                -- Number of lines within which surrounding is searched
                n_lines = 20,
                -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
                highlight_duration = 500,
                -- Module mappings. Use `''` (empty string) to disable one.
                mappings = {
                    add = 'sa', -- Add surrounding in Normal and Visual modes
                    delete = 'sd', -- Delete surrounding
                    find = 'sf', -- Find surrounding (to the right)
                    find_left = 'sF', -- Find surrounding (to the left)
                    highlight = 'sh', -- Highlight surrounding
                    replace = 'sr', -- Replace surrounding
                },
            }
        end,
    },

    -- { 'tpope/vim-surround' },
    -- { 'tpope/vim-sleuth' },
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
    -- {
    --     'junegunn/vim-easy-align',
    --     keys = {
    --         -- Normal mode mapping
    --         { 'ga', '<Plug>(EasyAlign)', mode = 'n', desc = 'EasyAlign (Normal Mode)' },
    --         -- Visual mode mapping
    --         { 'ga', '<Plug>(EasyAlign)', mode = 'x', desc = 'EasyAlign (Visual Mode)' },
    --     },
    --     config = function()
    --         -- Define custom delimiters for EasyAlign
    --         vim.g.easy_align_delimiter = {
    --             ['|'] = {
    --                 'align_on_pipe', -- This is a common style for pipes
    --                 'align_on_pipe_left', -- Align to the left of the pipe
    --                 'align_on_pipe_right', -- Align to the right of the pipe
    --                 'align_on_pipe_gap', -- Align based on the gap around the pipe
    --                 'align_on_pipe_outer', -- Align outer pipes (for table borders)
    --                 'align_on_pipe_inner', -- Align inner pipes (for column separators)
    --             },
    --             -- You can keep existing defaults or add others if you wish
    --             ['='] = { 'align_on_eq', 'align_on_equal', 'align_on_assign' },
    --             ['.'] = { 'align_on_dot' },
    --             -- Add any other delimiters you frequently use
    --         }
    --     end,
    -- },
    { 'nvim-mini/mini.align', version = false },
    -- In your init.lua, add this plugin:
    -- {
    --     '3rd/image.nvim',
    --     opts = {
    --         backend = 'kitty',
    --         integrations = {
    --             markdown = {
    --                 enabled = true,
    --                 clear_in_insert_mode = false,
    --                 download_remote_images = true,
    --                 only_render_image_at_cursor = false,
    --                 filetypes = { 'markdown' },
    --             },
    --         },
    --         max_width = nil,
    --         max_height = nil,
    --         max_width_window_percentage = nil,
    --         max_height_window_percentage = 50,
    --     },
    -- },

    {
        'folke/snacks.nvim',
        ---@type snacks.Config
        opts = {
            -- in order for this to worl we need imagemagic, ghostscript (pdf) and tectonic (math latex)
            image = {
                enabled = true,
                -- Disable file association to prevent BufReadCmd conflicts
                formats = {
                    'png',
                    'jpg',
                    'jpeg',
                    'gif',
                    'bmp',
                    'webp',
                },
                -- Configure to work within markdown context
                filetypes = { 'markdown', 'norg', 'tex' },
                doc = {
                    enabled = true,
                    inline = true,
                    max_width = 50, -- Set maximum width in columns
                    max_height = 20,
                },
            },
        },
    },
}
