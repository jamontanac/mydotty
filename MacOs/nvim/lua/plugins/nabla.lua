return {
    'jbyuki/nabla.nvim',
    ft = { 'markdown', 'tex', 'plaintex' },
    config = function()
        local function has_latex_parser()
            local ok, parser = pcall(vim.treesitter.get_parser, 0, 'latex')
            return ok and parser ~= nil
        end

        local function with_parser(fn)
            return function()
                if not has_latex_parser() then
                    vim.notify('nabla.nvim needs the latex parser. Run :TSInstall latex', vim.log.levels.WARN)
                    return
                end
                fn()
            end
        end

        vim.keymap.set('n', '<leader>mp', with_parser(function()
            require('nabla').popup { border = 'rounded' }
        end), { desc = '[M]ath [P]opup (nabla)' })

        vim.keymap.set('n', '<leader>mv', with_parser(function()
            require('nabla').toggle_virt()
        end), { desc = '[M]ath [V]irtual toggle (nabla)' })

        vim.keymap.set('n', '<leader>ma', with_parser(function()
            require('nabla').toggle_virt { autogen = true }
        end), { desc = '[M]ath [A]utogen toggle (nabla)' })
    end,
}