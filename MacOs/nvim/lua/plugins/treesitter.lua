-- Highlight, edit, and navigate code
return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
        'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
        require('nvim-treesitter.configs').setup {
            -- Add languages to be installed here that you want installed for treesitter
            ensure_installed = {
                'bash',
                'c',
                'cmake',
                'css',
                'dockerfile',
                'gitignore',
                'go',
                'graphql',
                'groovy',
                'html',
                'java',
                'javascript',
                'julia',
                'json',
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
            },

            -- Autoinstall languages that are not installed
            auto_install = true,

            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<leader>v',
                    node_incremental = '<leader>v',
                    scope_incremental = '<leader>V',
                    node_decremental = '<leader><BS>',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        [']f'] = '@function.outer',
                        [']c'] = '@class.outer',
                    },
                    goto_next_end = {
                        [']F'] = '@function.outer',
                        [']C'] = '@class.outer',
                    },
                    goto_previous_start = {
                        ['[f'] = '@function.outer',
                        ['[c'] = '@class.outer',
                    },
                    goto_previous_end = {
                        ['[F'] = '@function.outer',
                        ['[C'] = '@class.outer',
                    },
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ['<leader>sp'] = '@parameter.inner',
                    },
                    swap_previous = {
                        ['<leader>sP'] = '@parameter.inner',
                    },
                },
            },
        }

        -- Register additional file extension
        vim.filetype.add { extension = { tf = 'terraform' } }
        vim.filetype.add { extension = { tfvars = 'terraform' } }
        vim.filetype.add { extension = { pipeline = 'groovy' } }
        vim.filetype.add { extension = { multibranch = 'groovy' } }
    end,
}
