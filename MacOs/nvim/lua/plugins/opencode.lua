return {
    'NickvanDyke/opencode.nvim',
    dependencies = {
        { 'folke/snacks.nvim', opts = { input = {}, picker = {} } },
    },
    config = function()
        local opTerminal = require 'plugins.opencode-terminal'

        vim.g.opencode_opts = {
            -- Your custom terminal handler
            on_opencode_not_found = function()
                -- First, ensure the terminal exists and is visible
                opTerminal.ensure_opencode()
                -- Give it time to connect
                vim.defer_fn(function()
                    vim.notify('OpenCode terminal ready. Connect with: opencode --listen', vim.log.levels.INFO)
                end, 500)
            end,

            auto_reload = true,
        }

        vim.opt.autoread = true

        -- Your keymaps
        vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
            require('opencode').ask('@this: ', { submit = true })
        end, { desc = 'Ask about this' })

        vim.keymap.set({ 'n', 'x' }, '<leader>os', function()
            require('opencode').select()
        end, { desc = 'Select prompt' })

        vim.keymap.set({ 'n', 'x' }, '<leader>o+', function()
            require('opencode').prompt '@this'
        end, { desc = 'Add this' })

        -- vim.keymap.set('n', '<leader>oc', function()
        --     require('opencode').command()
        -- end, { desc = 'Select command' })
        --
        -- vim.keymap.set('n', '<leader>on', function()
        --     require('opencode').command 'session_new'
        -- end, { desc = 'New session' })

        vim.keymap.set('n', '<leader>oi', function()
            require('opencode').command 'session_interrupt'
        end, { desc = 'Interrupt session' })

        vim.keymap.set('n', '<leader>oA', function()
            require('opencode').command 'agent_cycle'
        end, { desc = 'Cycle selected agent' })

        -- Toggle terminal directly
        vim.keymap.set('n', '<leader>ot', function()
            opTerminal.toggle()
        end, { desc = 'Toggle opencode terminal' })
    end,
}
