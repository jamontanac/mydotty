-- Highlight, edit, and navigate code
local languages = {
    'bash',
    'c',
    'cmake',
    'comment',
    'css',
    'dockerfile',
    'gitignore',
    'go',
    'graphql',
    'groovy',
    'html',
    'java',
    'javascript',
    'json',
    'julia',
    'latex',
    'lua',
    'make',
    'markdown',
    'markdown_inline',
    'python',
    'regex',
    'rust',
    'sql',
    'terraform',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
    'scss',
    'svelte',
    'typst',
    'vue',
}

return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    dependencies = {
        {
            'nvim-treesitter/nvim-treesitter-textobjects',
            config = function()
                require('nvim-treesitter-textobjects').setup {
                    select = { lookahead = true },
                    move = { set_jumps = true },
                }

                local select = require 'nvim-treesitter-textobjects.select'
                local move = require 'nvim-treesitter-textobjects.move'
                local swap = require 'nvim-treesitter-textobjects.swap'

                for _, mode in ipairs { 'x', 'o' } do
                    vim.keymap.set(mode, 'aa', function()
                        select.select_textobject('@parameter.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, 'ia', function()
                        select.select_textobject('@parameter.inner', 'textobjects')
                    end)
                    vim.keymap.set(mode, 'af', function()
                        select.select_textobject('@function.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, 'if', function()
                        select.select_textobject('@function.inner', 'textobjects')
                    end)
                    vim.keymap.set(mode, 'ac', function()
                        select.select_textobject('@class.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, 'ic', function()
                        select.select_textobject('@class.inner', 'textobjects')
                    end)
                end

                for _, mode in ipairs { 'n', 'x', 'o' } do
                    vim.keymap.set(mode, ']f', function()
                        move.goto_next_start('@function.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, ']c', function()
                        move.goto_next_start('@class.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, ']F', function()
                        move.goto_next_end('@function.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, ']C', function()
                        move.goto_next_end('@class.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, '[f', function()
                        move.goto_previous_start('@function.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, '[c', function()
                        move.goto_previous_start('@class.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, '[F', function()
                        move.goto_previous_end('@function.outer', 'textobjects')
                    end)
                    vim.keymap.set(mode, '[C', function()
                        move.goto_previous_end('@class.outer', 'textobjects')
                    end)
                end

                vim.keymap.set('n', '<leader>sp', function()
                    swap.swap_next '@parameter.inner'
                end)
                vim.keymap.set('n', '<leader>sP', function()
                    swap.swap_previous '@parameter.inner'
                end)
            end,
        },
    },
    config = function()
        require('nvim-treesitter').setup()
        require('nvim-treesitter').install(languages)

        vim.api.nvim_create_autocmd('FileType', {
            pattern = '*',
            callback = function(args)
                pcall(vim.treesitter.start, args.buf)
            end,
        })

        -- Register additional file extension
        vim.filetype.add { extension = { tf = 'terraform' } }
        vim.filetype.add { extension = { tfvars = 'terraform' } }
        vim.filetype.add { extension = { pipeline = 'groovy' } }
        vim.filetype.add { extension = { multibranch = 'groovy' } }
    end,
}
