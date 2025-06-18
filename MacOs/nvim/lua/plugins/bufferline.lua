return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "moll/vim-bbye",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers",        -- set to "tabs" to only show tabs
                themable = true,         -- enable theming
                numbers = "none",        -- set to "ordinal" to show buffer numbers
                close_command = "Bdelete! %d", -- command to close the buffer
                right_mouse_command = "Bdelete! %d", -- command for right click on buffer
                left_mouse_command = "buffer %d", -- command for left click on buffer
                middle_mouse_command = nil, -- command for middle click on buffer
                -- indicator_icon = '▎', -- icon for the active buffer indicator
                indicator = {
                    -- icon = '▎', -- this should be omitted if indicator style is not 'icon'
                    style = "none", -- Options: 'icon', 'underline', 'none'
                },
                buffer_close_icon = "✗", -- icon for closing a buffer
                modified_icon = "●", -- icon for modified buffers
                close_icon = "", -- icon for closing a buffer
                path_components = 1, -- Show only the file name without the directory
                left_trunc_marker = "",
                right_trunc_marker = "",
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
                separator_style = { "│", "|" }, -- | "thick" | "thin" | { 'any', 'any' },
                enforce_regular_tabs = true,
                always_show_bufferline = true,
                show_tab_indicators = false,
                -- separator_style = "slant", -- style of the separator between buffers
                -- enforce_regular_tabs = false, -- enforce regular tabs
                -- always_show_bufferline = true, -- always show the bufferline
                icon_pinned = "󰐃",
                minimum_padding = 1,
                maximum_padding = 5,
                maximum_length = 15,
                sort_by = "insert_at_end",
                hover = {
                    enabled = true,
                    delay = 200,
                    reveal = { "close" },
                },
            },
            highlights = {
                separator = {
                    fg = "#9ccfd8",
                },
                buffer_selected = {
                    bold = true,
                    italic = false,
                },
            },
        })
        vim.keymap.set(
            "n",
            "[b",
            "<cmd>BufferLineCycleNext<CR>",
            { silent = true, noremap = true, desc = "Cycle to next buffer" }
        )
        vim.keymap.set(
            "n",
            "]b",
            "<cmd>BufferLineCyclePrev<CR>",
            { silent = true, noremap = true, desc = "Cycle to previous buffer" }
        )
    end,
}
