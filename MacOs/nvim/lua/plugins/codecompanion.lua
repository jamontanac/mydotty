return {
    'olimorris/codecompanion.nvim',
    version = '^18.0.0',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-telescope/telescope.nvim',
        -- MCP support - uncomment when needed:
        -- 'ravitemer/mcphub.nvim',
    },
    cmd = { 'CodeCompanionChat', 'CodeCompanionActions', 'CodeCompanion' },
    opts = {
        -- [1] ADAPTER CONFIGURATION
        adapters = {
            copilot = function()
                return require('codecompanion.adapters').extend('copilot', {
                    schema = {
                        model = {
                            -- Let it resolve dynamically or use standard 'gpt-4o' / 'claude-3-5-sonnet'
                            -- depending on what your Github Copilot account has unlocked.
                            default = '',
                        },
                    },
                })
            end,
        },

        -- [2] INTERACTIONS (Renamed from strategies)
        interactions = {
            chat = {
                adapter = 'copilot',
                slash_commands = {
                    ['buffer'] = {
                        opts = { provider = 'telescope' },
                    },
                    ['file'] = {
                        opts = { provider = 'telescope' },
                    },
                },
            },
            inline = {
                adapter = 'copilot',
            },
        },

        -- [3] DISPLAY CONFIGURATION
        display = {
            chat = {
                window = {
                    layout = 'vertical',
                    width = 0.45,
                    height = 0.8,
                    relative = 'editor',
                    border = 'rounded',
                },
                show_settings = true,
                show_token_count = true,
            },
            diff = {
                provider = 'mini_diff',
            },
            action_palette = {
                width = 95,
                height = 10,
                provider = 'telescope',
            },
        },

        -- [4] GLOBAL OPTIONS
        opts = {
            log_level = 'ERROR',
            send_code = true,
            use_default_actions = true,
            use_default_prompt_library = true,
        },

        -- [5] PROMPT LIBRARY (Using up-to-date interpolation strings)
        prompt_library = {
            ['Explain'] = {
                strategy = 'chat',
                description = 'Explain the selected code',
                prompts = {
                    {
                        role = 'user',
                        content = 'Explain this code clearly and concisely:\n\n```{{filetype}}\n{{selection}}\n',
                    },
                },
            },
            ['Review'] = {
                strategy = 'chat',
                description = 'Review the selected code',
                prompts = {
                    {
                        role = 'user',
                        content = 'Review this code for:\n1. Potential bugs\n2. Performance issues\n3. Best practices\n4. Readability\n\n```{{filetype}}\n{{selection}}\n```',
                    },
                },
            },
            ['Fix'] = {
                strategy = 'inline',
                description = 'Fix issues in the selected code',
                prompts = {
                    {
                        role = 'user',
                        content = 'Fix any issues in this code and return the corrected version:\n\n```{{filetype}}\n{{selection}}\n',
                    },
                },
            },
        },
    },

    -- [6] KEYBINDINGS
    keys = {
        { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = '[A]I [A]ctions picker' },
        { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = '[A]I [C]hat sidebar' },
        { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = '[A]I [I]nline assistant' },
        { '<leader>aq', '<cmd>CodeCompanionChat<cr>', mode = { 'n', 'v' }, desc = '[A]I [Q]uick question' },

        -- Visual mode selections
        { '<leader>ap', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', desc = '[A]I: Add selection to chat' },
        { '<leader>ae', '<cmd>CodeCompanionChat Explain<cr>', mode = 'v', desc = '[A]I: [E]xplain code' },
        { '<leader>ar', '<cmd>CodeCompanionChat Review<cr>', mode = 'v', desc = '[A]I: [R]eview code' },
        { '<leader>ax', '<cmd>CodeCompanionChat Fix<cr>', mode = 'v', desc = '[A]I: Fi[x] code' },
    },
}
