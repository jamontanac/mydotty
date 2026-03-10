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

    config = function()
        require('codecompanion').setup {
            -- [1] ADAPTER CONFIGURATION
            adapters = {
                copilot = function()
                    return require('codecompanion.adapters').extend('copilot', {
                        schema = {
                            model = {
                                default = 'gpt-41-copilot',
                                -- TODO: Update to 'gpt-5-codex' when available via GitHub Copilot
                                -- Check available models: https://github.com/features/copilot
                            },
                        },
                    })
                end,
            },

            -- [2] STRATEGIES - Chat & Inline
            strategies = {
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

            -- [3] DISPLAY - Sidebar (default)
            display = {
                chat = {
                    window = {
                        layout = 'vertical', -- Sidebar mode by default
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

            -- [4] OPTIONS
            opts = {
                log_level = 'ERROR',
                send_code = true,
                use_default_actions = true,
                use_default_prompt_library = true,
            },

            -- [5] CUSTOM PROMPTS (Explain, Review, Fix)
            prompt_library = {
                ['Explain'] = {
                    strategy = 'chat',
                    description = 'Explain the selected code',
                    prompts = {
                        {
                            role = 'user',
                            content = 'Explain this code clearly and concisely:\n\n```{{filetype}}\n{{selection}}\n```',
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
                            content = 'Fix any issues in this code and return the corrected version:\n\n```{{filetype}}\n{{selection}}\n```',
                        },
                    },
                },
            },

            -- [6] FUTURE MCP CONFIGURATION (ready to enable)
            -- Uncomment and configure when you want to add MCP servers:
            -- mcp = {
            --   enabled = true,
            --   servers = {
            --     -- Example: Filesystem MCP server
            --     filesystem = {
            --       command = 'npx',
            --       args = { '-y', '@modelcontextprotocol/server-filesystem', vim.fn.expand '~' },
            --     },
            --     -- Example: Git MCP server
            --     -- git = {
            --     --   command = 'npx',
            --     --   args = { '-y', '@modelcontextprotocol/server-git' },
            --     -- },
            --   },
            -- },
        }

        --     -- [7] CUSTOM FLOATING CHAT COMMAND
        --     vim.api.nvim_create_user_command('CodeCompanionChatFloat', function(opts)
        --         -- Calculate centered floating window dimensions (70% of screen)
        --         local width = math.floor(vim.o.columns * 0.7)
        --         local height = math.floor(vim.o.lines * 0.7)
        --         local row = math.floor((vim.o.lines - height) / 2)
        --         local col = math.floor((vim.o.columns - width) / 2)
        --
        --         -- Get current config
        --         local codecompanion_config = require 'codecompanion.config'
        --         local original_layout = codecompanion_config.display.chat.window.layout
        --         local original_width = codecompanion_config.display.chat.window.width
        --         local original_height = codecompanion_config.display.chat.window.height
        --
        --         -- Set floating window config
        --         codecompanion_config.display.chat.window.layout = 'float'
        --         codecompanion_config.display.chat.window.width = width
        --         codecompanion_config.display.chat.window.height = height
        --         codecompanion_config.display.chat.window.row = row
        --         codecompanion_config.display.chat.window.col = col
        --         codecompanion_config.display.chat.window.border = 'rounded'
        --
        --         -- Open the chat
        --         vim.cmd('CodeCompanionChat ' .. (opts.args or ''))
        --
        --         -- Get the chat buffer
        --         vim.schedule(function()
        --             local buf = vim.api.nvim_get_current_buf()
        --             local bufname = vim.api.nvim_buf_get_name(buf)
        --
        --             -- Only set keymap if this is actually a CodeCompanion buffer
        --             if bufname:match 'codecompanion' then
        --                 -- Map <Esc> to close the floating window
        --                 vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', {
        --                     buffer = buf,
        --                     desc = 'Close floating chat',
        --                     noremap = true,
        --                     silent = true,
        --                 })
        --
        --                 -- Restore original config when buffer is closed
        --                 vim.api.nvim_create_autocmd('BufLeave', {
        --                     buffer = buf,
        --                     once = true,
        --                     callback = function()
        --                         codecompanion_config.display.chat.window.layout = original_layout
        --                         codecompanion_config.display.chat.window.width = original_width
        --                         codecompanion_config.display.chat.window.height = original_height
        --                     end,
        --                 })
        --             end
        --         end)
        --     end, { nargs = '?', desc = 'Open CodeCompanion in floating window (70%, rounded, <Esc> to close)' })
    end,

    -- [8] KEYBINDINGS - Full <leader>a* namespace
    keys = {
        -- Main actions
        { '<leader>aa', '<cmd>CodeCompanionActions<cr>', mode = { 'n', 'v' }, desc = '[A]I [A]ctions picker' },
        { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', mode = { 'n', 'v' }, desc = '[A]I [C]hat sidebar' },
        -- { '<leader>af', '<cmd>CodeCompanionChatFloat<cr>', mode = { 'n', 'v' }, desc = '[A]I chat [F]loating' },
        { '<leader>ai', '<cmd>CodeCompanion<cr>', mode = { 'n', 'v' }, desc = '[A]I [I]nline assistant' },
        { '<leader>aq', '<cmd>CodeCompanionChat<cr>', mode = { 'n', 'v' }, desc = '[A]I [Q]uick question' },

        -- Visual mode - quick actions with selections
        { '<leader>ap', '<cmd>CodeCompanionChat Add<cr>', mode = 'v', desc = '[A]I: Add selection to chat' },
        { '<leader>ae', '<cmd>CodeCompanionChat Explain<cr>', mode = 'v', desc = '[A]I: [E]xplain code' },
        { '<leader>ar', '<cmd>CodeCompanionChat Review<cr>', mode = 'v', desc = '[A]I: [R]eview code' },
        { '<leader>ax', '<cmd>CodeCompanionChat Fix<cr>', mode = 'v', desc = '[A]I: Fi[x] code' },
    },
}
