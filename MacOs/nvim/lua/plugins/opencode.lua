return {
    'NickvanDyke/opencode.nvim',
    dependencies = {
        { 'folke/snacks.nvim', opts = { input = {}, picker = {} } },
    },
    -- We use 'init' because opencode.nvim explicitly reads from the global
    -- vim.g.opencode_opts variable during its internal initialization phase.
    init = function()
        local opTerminal = require 'plugins.opencode-terminal'

        vim.g.opencode_opts = {
            auto_reload = true,
            on_opencode_not_found = function()
                -- Ensure backend connection is active
                opTerminal.ensure_opencode()
                vim.defer_fn(function()
                    vim.notify('OpenCode terminal ready. Connect with: opencode --port', vim.log.levels.INFO)
                end, 500)
            end,
        }
    end,
    config = function()
        -- Initialize the plugin options safely
        -- require('opencode').setup(opts)

        vim.opt.autoread = true
        -- [KEYMAP RESTRUCTURING]
        -- Moving off <C-a> / <C-x> to keep math increments intact
        -- Using an ergonomic and highly clear leader setup

        -- Your keymaps
        vim.keymap.set({ 'n', 'x' }, '<leader>at', function()
            require('opencode').ask('@this: ', { submit = true })
        end, { desc = 'Ask about this' })

        vim.keymap.set({ 'n', 'x' }, '<leader>as', function()
            require('opencode').select()
        end, { desc = 'Select prompt' })

        vim.keymap.set({ 'n', 'x' }, '<leader>a.', function()
            require('opencode').prompt '@this'
        end, { desc = 'Add this' })

        vim.keymap.set({ 'n', 'x' }, '<leader>ab', function()
            require('opencode').prompt '@buffer'
        end, { desc = 'Add buffer' })

        vim.keymap.set({ 'n', 'x' }, '<leader>aab', function()
            require('opencode').prompt '@buffers'
        end, { desc = 'Add all buffers' })

        vim.keymap.set('n', '<leader>a<tab>', function()
            require('opencode').command 'agent.cycle'
        end, { desc = 'Cycle selected agent' })

        vim.keymap.set('n', '<leader>ac', function()
            require('opencode').command('session.select')
        end, { desc = 'Choose session' })

        vim.keymap.set('n', '<leader>an', function()
            require('opencode').command('session.new')
        end, { desc = 'New session' })

        -- vim.keymap.set({ 'n', 't' }, '<leader>oc', function()
        --     require('opencode').toggle()
        -- end, { desc = 'Toggle opencode' })
        -- vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment under cursor', noremap = true })
        -- vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement under cursor', noremap = true })

        -- vim.keymap.set('n', '<leader>oc', function()
        --     require('opencode').command()
        -- end, { desc = 'Select command' })
        --
        -- vim.keymap.set('n', '<leader>on', function()
        --     require('opencode').command 'session_new'
        -- end, { desc = 'New session' })

        -- vim.keymap.set('n', '<leader>oi', function()
        --     require('opencode').command 'session_interrupt'
        -- end, { desc = 'Interrupt session' })
        --
        -- vim.keymap.set('n', '<leader>oA', function()
        --     require('opencode').command 'agent_cycle'
        -- end, { desc = 'Cycle selected agent' })
        --
        -- -- Toggle terminal directly
        -- vim.keymap.set('n', '<leader>ot', function()
        --     opTerminal.toggle()
        -- end, { desc = 'Toggle opencode terminal' })
    end,
}
