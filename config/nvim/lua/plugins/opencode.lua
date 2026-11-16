return {
    'NickvanDyke/opencode.nvim',
    dependencies = {
        { 'folke/snacks.nvim', opts = { input = {}, picker = {} } },
    },
    -- No vim.g.opencode_opts needed: the old `auto_reload` / `on_opencode_not_found` keys no
    -- longer exist in opencode.nvim (reload is now `events.reload`, on by default), and
    -- plugins/opencode-terminal.lua is fully commented out.
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

        -- vim.keymap.set('n', '<leader>oi', function()
        --     require('opencode').command 'session_interrupt'
        -- end, { desc = 'Interrupt session' })
    end,
}
