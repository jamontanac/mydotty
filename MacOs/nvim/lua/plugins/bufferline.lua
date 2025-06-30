return {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = {
        { 'echasnovski/mini.icons', opts = {} },
        'moll/vim-bbye',
        'nvim-lua/plenary.nvim',
    },
    config = function()
        require('bufferline').setup {
            options = {
                mode = 'buffers', -- set to "tabs" to only show tabs
                themable = true, -- enable theming
                numbers = function(opts)
                    return string.format('%s', opts.raise(opts.ordinal))
                end, -- set to "ordinal" to show buffer numbers
                close_command = 'Bdelete! %d', -- command to close the buffer
                right_mouse_command = 'Bdelete! %d', -- command for right click on buffer
                left_mouse_command = 'buffer %d', -- command for left click on buffer
                middle_mouse_command = nil, -- command for middle click on buffer
                -- indicator_icon = '▎', -- icon for the active buffer indicator
                indicator = {
                    -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
                    style = 'none', -- Options: 'icon', 'underline', 'none'
                },
                buffer_close_icon = '✗', -- icon for closing a buffer
                modified_icon = '●', -- icon for modified buffers
                close_icon = '', -- icon for closing a buffer
                path_components = 1, -- Show only the file name without the directory
                left_trunc_marker = '',
                right_trunc_marker = '',
                max_name_length = 30,
                max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
                tab_size = 21,
                diagnostics = false,
                diagnostics_update_in_insert = false,
                color_icons = true,
                show_buffer_icons = true,
                show_buffer_close_icons = true,
                show_close_icon = true,
                persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
                separator_style = { '│', '|' }, -- | "thick" | "thin" | { 'any', 'any' },
                enforce_regular_tabs = true,
                always_show_bufferline = true,
                show_tab_indicators = true,
                -- separator_style = "slant", -- style of the separator between buffers
                -- enforce_regular_tabs = true, -- enforce regular tabs
                get_element_icon = function(element)
                    if not MiniIcons then
                        return
                    end
                    local icon, hl, is_default = MiniIcons.get('file', element.path or element.filename)
                    return icon, hl
                end, -- function to get the icon for a buffer element
                -- always_show_bufferline = true, -- always show the bufferline
                -- filter out the navigation in oil
                custom_filter = function(buf_number)
                    local filetype = vim.bo[buf_number].filetype
                    return filetype ~= 'oil' and filetype ~= 'alpha'
                end,
                icon_pinned = '󰐃',
                minimum_padding = 1,
                maximum_padding = 5,
                maximum_length = 15,
                sort_by = 'insert_at_end',
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { 'close' },
                },
                pick = {
                    alphabet = 'abcdefghijklmopqrstuvwxyz',
                },
                groups = {
                    options = {
                        toggle_hidden_on_enter = true, -- toggle hidden buffers on enter
                    },
                    items = {
                        {
                            name = 'Tests',
                            priority = 2,
                            icon = ' ', -- Optional
                            highlight = { underline = true, sp = '#907aa9' },
                            auto_close = true,
                            matcher = function(buf) -- Mandatory
                                return buf.name:match '_test' or buf.name:match 'test_'
                            end,
                        },
                        {
                            name = 'Docs',
                            priority = 1,
                            icon = '󱉟 ',
                            highlight = { underline = true, sp = '#286983' },
                            auto_close = true, -- Automatically close the group when empty
                            matcher = function(buf)
                                return buf.name:match '%.md$' or buf.name:match '%.txt$'
                            end,
                        },
                    },
                },
            },
            highlights = {
                separator = {
                    fg = '#9ccfd8',
                },
                buffer_selected = {
                    bold = true,
                    italic = false,
                },
            },
        }
        vim.keymap.set(
            'n',
            '<leader>pb',
            '<cmd>BufferLinePick<CR>',
            { silent = true, noremap = true, desc = '[P]ick a [B]uffer' }
        )
        vim.keymap.set(
            'n',
            '<leader>tg1',
            '<cmd>BufferLineGroupToggle Docs<CR>',
            { silent = true, noremap = true, desc = '[T]oggle [G]roup Docs' }
        )
        vim.keymap.set(
            'n',
            '<leader>tg2',
            '<cmd>BufferLineGroupToggle Tests<CR>',
            { silent = true, noremap = true, desc = '[T]oggle [G]roup Tests' }
        )
        vim.keymap.set(
            'n',
            'gb1',
            '<cmd>BufferLineGoToBuffer 1<CR>',
            { silent = true, noremap = true, desc = '[G]o to [B]uffer 1' }
        )
        vim.keymap.set(
            'n',
            'gb2',
            '<cmd>BufferLineGoToBuffer 2<CR>',
            { silent = true, noremap = true, desc = '[G]o to [B]uffer 2' }
        )
        vim.keymap.set(
            'n',
            'gb3',
            '<cmd>BufferLineGoToBuffer 3<CR>',
            { silent = true, noremap = true, desc = '[G]o to [B]uffer 3' }
        )
        vim.keymap.set(
            'n',
            'gb4',
            '<cmd>BufferLineGoToBuffer 4<CR>',
            { silent = true, noremap = true, desc = '[G]o to [B]uffer 4' }
        )
        vim.keymap.set(
            'n',
            'gb5',
            '<cmd>BufferLineGoToBuffer 5<CR>',
            { silent = true, noremap = true, desc = '[G]o to [B]uffer 5' }
        )
        -- vim.keymap.set(
        --     'n',
        --     '<A-.>',
        --     '<cmd>BufferLineCycleNext<CR>',
        --     { silent = true, noremap = true, desc = 'Cycle to next buffer' }
        -- )
        vim.keymap.set(
            'n',
            '<A-,>',
            '<cmd>BufferLineCycleNext<CR>',
            { silent = true, noremap = true, desc = 'Cycle to next buffer' }
        )
    end,
}
