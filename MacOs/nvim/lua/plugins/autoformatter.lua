return { -- Autoformat
    'stevearc/conform.nvim',
    dependencies = {
        'williamboman/mason.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>f',
            function()
                require('conform').format { async = true, lsp_format = 'fallback' }
            end,
            mode = '',
            desc = '[F]ormat [F]ile buffer',
        },
    },
    config = function()
        -- First, setup mason-tool-installer to ensure formatters are installed
        require('mason-tool-installer').setup {
            ensure_installed = {
                'checkmake', -- makefile linter
                'prettier', -- ts/js formatter
                -- 'prittierd', -- ts/js formatter (alternative)
                'stylua', -- lua formatter
                'shfmt', -- shell formatter
                'ruff', -- python formatter/linter
                'JuliaFormatter', -- julia formatter
                'jq', -- JSON formatter
            },
            -- auto-install configured formatters (matching your original setup)
            auto_update = true,
            run_on_start = true,
        }
        -- Setup conform.nvim
        require('conform').setup {
            notify_on_error = false,
            format_after_save = { lsp_format = 'fallback' }, -- Use LSP formatting as fallback
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = 'fallback',
                    }
                end
            end,
            -- notify_on_error = false, -- Disable notifications on error
            formatters_by_ft = {
                -- Prettier for web technologies
                javascript = { 'prettier' },
                -- typescript = { 'prettier' },
                html = { 'prettier' },
                json = { 'jq' },
                css = { 'prettier' },
                markdown = { 'prettier' },
                yaml = { 'prettier_yaml' },

                -- Lua formatter
                lua = { 'stylua' },

                --shell script formatter
                sh = { 'shfmt' },
                bash = { 'shfmt' },

                --Terraform formatter
                terraform = { 'terraform_fmt' },
                tf = { 'terraform_fmt' },
                hcl = { 'terraform_fmt' },

                -- python formatter
                python = { 'ruff', 'ruff_format' }, -- Use ruff for Python formatting

                -- Makefile linter
                makefile = { 'checkmake' },

                -- Julia formatter
                julia = { 'JuliaFormatter' }, -- Julia formatter
            },

            formatters = {
                --configure shfmt
                shfmt = { prepend_args = { '-i', '2' } }, -- 2 spaces indentation for shell scripts

                --configure ruff
                ruff_organize_imports = {
                    extra_args = { '--extend-select', 'I' }, -- Include additional checks for imports
                },
                prettier_yaml = {
                    command = 'prettier',
                    inherit = false,
                    args = { '--stdin-filepath', '$FILENAME', '--tab-width', '4' }, -- Use 4 spaces for JSON files
                },
                jq = {
                    command = 'jq',
                    args = { '--indent', '4', '.' }, -- Use 4 spaces for JSON files
                    stdin = true,
                },
            },
        }
    end,
}
--   opts = {
--     notify_on_error = false,
--     format_on_save = function(bufnr)
--       -- Disable "format_on_save lsp_fallback" for languages that don't
--       -- have a well standardized coding style. You can add additional
--       -- languages here or re-enable it for the disabled ones.
--       local disable_filetypes = { c = true, cpp = true }
--       if disable_filetypes[vim.bo[bufnr].filetype] then
--         return nil
--       else
--         return {
--           timeout_ms = 500,
--           lsp_format = 'fallback',
--         }
--       end
--     end,
--     formatters_by_ft = {
--       lua = { 'stylua' },
--       -- Conform can also run multiple formatters sequentially
--       -- python = { "isort", "black" },
--       --
--       -- You can use 'stop_after_first' to run the first available formatter from the list
--       -- javascript = { "prettierd", "prettier", stop_after_first = true },
--     },
--   },
-- }

-- Format on save and linters
-- return {
--   'nvimtools/none-ls.nvim',
--   dependencies = {
--     'nvimtools/none-ls-extras.nvim',
--     'jayp0521/mason-null-ls.nvim',     -- ensure dependencies are installed
--   },
--   config = function()
--     local null_ls = require 'null-ls'
--     local formatting = null_ls.builtins.formatting       -- to setup formatters
--     local diagnostics = null_ls.builtins.diagnostics     -- to setup linters
--
--     -- list of formatters & linters for mason to install
--     require('mason-null-ls').setup {
--       ensure_installed = {
--         'checkmake',
--         'prettier',         -- ts/js formatter
--         'stylua',           -- lua formatter
--         'eslint_d',         -- ts/js linter
--         'shfmt',
--         'ruff',
--       },
--       -- auto-install configured formatters & linters (with null-ls)
--       automatic_installation = true,
--     }
--
--     local sources = {
--       diagnostics.checkmake,
--       formatting.prettier.with { filetypes = { 'html', 'json', 'yaml', 'markdown', 'javascript', 'css' } },
--       formatting.stylua,
--       formatting.shfmt.with { args = { '-i', '2' } },
--       formatting.terraform_fmt,
--       require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
--       require 'none-ls.formatting.ruff_format',
--     }
--
--     local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
--     null_ls.setup {
--       -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
--       sources = sources,
--       -- you can reuse a shared lspconfig on_attach callback here
--       on_attach = function(client, bufnr)
--         if client.supports_method 'textDocument/formatting' then
--           vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
--           vim.api.nvim_create_autocmd('BufWritePre', {
--             group = augroup,
--             buffer = bufnr,
--             callback = function()
--               vim.lsp.buf.format { async = false }
--             end,
--           })
--         end
--       end,
--     }
--   end,
-- }
