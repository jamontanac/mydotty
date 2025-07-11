return {
    'romgrk/barbar.nvim',
    dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        'moll/vim-bbye',
    },
    lazy = false,
    init = function()
        vim.g.have_nerd_font = true -- ensure this is set
        vim.g.barbar_auto_setup = false
    end,
    opts = {
        -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
        animation = true,
        -- Enable/disable current/total tabpages indicator (top right corner)
        tabpages = true,
        -- Enables/disable clickable tabs
        --  - left-click: go to buffer
        --  - middle-click: delete buffer
        clickable = true,
        exclude_ft = { 'oil', 'alpha', 'neo-tree', 'Avante' }, -- filetypes to exclude from the bufferline
        insert_at_start = true,
        icons = {
            -- Configure the base icons on the bufferline.
            --     -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
            buffer_index = false,
            buffer_number = false,
            button = '',
            --                     -- Enables / disables diagnostic symbols
            diagnostics = {
                [vim.diagnostic.severity.ERROR] = { enabled = true, icon = '󰅚 ' },
                [vim.diagnostic.severity.WARN] = { enabled = false },
                [vim.diagnostic.severity.INFO] = { enabled = false },
                [vim.diagnostic.severity.HINT] = { enabled = false },
            },
            gitsigns = {
                added = { enabled = false, icon = '+' },
                changed = { enabled = false, icon = '~' },
                deleted = { enabled = false, icon = '-' },
            },
            filetype = {
                -- Sets the icon's highlight group.
                -- If false, will use nvim-web-devicons colors
                custom_colors = false,

                -- Requires `nvim-web-devicons` if `true`
                enabled = true,
            },
            separator = { left = '▎', right = '' },

            -- If true, add an additional separator at the end of the buffer list
            separator_at_end = true,

            -- Configure the icons on the bufferline when modified or pinned.
            -- Supports all the base icon options.
            modified = { button = '●' },
            pinned = { button = '', filename = true },

            -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
            preset = 'default',

            -- Configure the icons on the bufferline based on the visibility of a buffer.
            -- Supports all the base icon options, plus `modified` and `pinned`.
            alternate = { filetype = { enabled = false } },
            current = { buffer_index = true },
            inactive = { button = '×' },
            visible = { modified = { buffer_number = false } },
        },
        -- …etc.
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
}
