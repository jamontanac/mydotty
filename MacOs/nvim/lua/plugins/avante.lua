return {
    'yetone/avante.nvim',
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make', -- ⚠️ must add this line! ! !
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    event = 'VeryLazy',
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
        ---@type Provider
        provider = 'copilot', -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
        ---@alias Mode "agentic" | "legacy"
        ---@type Mode
        mode = 'agentic', -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
        -- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
        -- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
        -- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
        auto_suggestions_provider = 'copilot',
        behaviour = {
            enable_fastapply = false, -- Enable Fast Apply feature
            auto_apply_diff_after_generation = false,
            auto_approve_tool_permissions = false,
            auto_set_highlight_group = true,
        },
        providers = {
            copilot = {
                endpoint = 'https://api.githubcopilot.com',
                model = 'gpt-4o-2024-11-20',
                proxy = nil, -- [protocol://]host[:port] Use this proxy
                allow_insecure = false, -- Allow insecure server connections
                timeout = 30000, -- Timeout in milliseconds
                context_window = 64000, -- Number of tokens to send to the model for context
                extra_request_body = {
                    temperature = 0.15,
                    max_tokens = 20480,
                },
            },
            claude = {
                endpoint = 'https://api.anthropic.com',
                model = 'claude-sonnet-4-20250514',
                extra_request_body = {
                    temperature = 0.25,
                    max_tokens = 20000,
                },
                openai = {
                    endpoint = 'https://api.openai.com',
                    model = 'gpt-4o',
                    extra_request_body = {
                        temperature = 0.25,
                        max_tokens = 40000,
                    },
                },
            },
        },
        ---Specify the special dual_boost mode
        ---1. enabled: Whether to enable dual_boost mode. Default to false.
        ---2. first_provider: The first provider to generate response. Default to "openai".
        ---3. second_provider: The second provider to generate response. Default to "claude".
        ---4. prompt: The prompt to generate response based on the two reference outputs.
        ---5. timeout: Timeout in milliseconds. Default to 60000.
        ---How it works:
        --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
        ---Note: This is an experimental feature and may not work as expected.
        dual_boost = {
            enabled = false,
            first_provider = 'openai',
            second_provider = 'claude',
            prompt = 'Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]',
            timeout = 60000, -- Timeout in milliseconds
        },
        -- mappings = {
        --     diff = {
        --         ours = 'co',
        --         theirs = 'ct',
        --         all_theirs = 'ca', -- This is your "apply all" function
        --         both = 'cb',
        --         cursor = 'cc',
        --         next = ']x',
        --         prev = '[x',
        --     },
        --     ask = {
        --         focus = '<c-s>',
        --         edit = '<c-i>',
        --         refresh = 'r',
        --         diff = 'd',
        --     },
        --     submit = {
        --         normal = '<CR>',
        --         insert = '<C-s>',
        --     },
        --     sidebar = {
        --         apply_all = 'A', -- ✅ This should show your apply all button
        --         apply_cursor = 'a', -- ✅ This should show your apply current button
        --         switch_windows = '<Tab>',
        --         reverse_switch_windows = '<S-Tab>',
        --     },
        -- },
        highlights = {
            diff = {
                current = 'DiffText',
                incoming = 'DiffAdd',
            },
        },
    },

    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-lua/plenary.nvim',
        'MunifTanjim/nui.nvim',
        --- The below dependencies are optional,
        'echasnovski/mini.pick', -- for file_selector provider mini.pick
        'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
        'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
        'ibhagwan/fzf-lua', -- for file_selector provider fzf
        'stevearc/dressing.nvim', -- for input provider dressing
        'folke/snacks.nvim', -- for input provider snacks
        'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
        'zbirenbaum/copilot.lua', -- for providers='copilot'
        {
            -- support for image pasting
            'HakonHarnes/img-clip.nvim',
            event = 'VeryLazy',
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { 'markdown', 'Avante' },
            },
            ft = { 'markdown', 'Avante' },
        },
    },
}
