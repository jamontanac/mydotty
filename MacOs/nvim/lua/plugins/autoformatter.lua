-- return { -- Autoformat
--     'stevearc/conform.nvim',
--     event = { 'BufWritePre' },
--     cmd = { 'ConformInfo' },
--     keys = {
--       {
--         '<leader>ff',
--         function()
--           require('conform').format { async = true, lsp_format = 'fallback' }
--         end,
--         mode = '',
--         desc = '[F]ormat [F]ile buffer',
--       },
--     },
--     opts = {
--       notify_on_error = false,
--       format_on_save = function(bufnr)
--         -- Disable "format_on_save lsp_fallback" for languages that don't
--         -- have a well standardized coding style. You can add additional
--         -- languages here or re-enable it for the disabled ones.
--         local disable_filetypes = { c = true, cpp = true }
--         if disable_filetypes[vim.bo[bufnr].filetype] then
--           return nil
--         else
--           return {
--             timeout_ms = 500,
--             lsp_format = 'fallback',
--           }
--         end
--       end,
--       formatters_by_ft = {
--         lua = { 'stylua' },
--         -- Conform can also run multiple formatters sequentially
--         -- python = { "isort", "black" },
--         --
--         -- You can use 'stop_after_first' to run the first available formatter from the list
--         -- javascript = { "prettierd", "prettier", stop_after_first = true },
--       },
--     },
--   },
-- Format on save and linters
return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    -- list of formatters & linters for mason to install
    require("mason-null-ls").setup({
      ensure_installed = {
        "checkmake",
        "prettier", -- ts/js formatter
        "stylua", -- lua formatter
        "eslint_d", -- ts/js linter
        "shfmt",
        "ruff",
      },
      -- auto-install configured formatters & linters (with null-ls)
      automatic_installation = true,
    })

    local sources = {
      diagnostics.checkmake,
      formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
      formatting.stylua,
      formatting.shfmt.with({ args = { "-i", "4" } }),
      formatting.terraform_fmt,
      require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
      require("none-ls.formatting.ruff_format"),
    }

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
}
