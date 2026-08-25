return {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    requires = {
        'copilotlsp-nvim/copilot-lsp', -- (optional) for NES functionality
    },
    build = ':Copilot auth',
    event = 'InsertEnter',
    config = function()
        require('copilot').setup {
            -- Kept disabled so blink.cmp can handle the UI
            suggestion = { enabled = false },
            panel = { enabled = false },

            filetypes = {
                markdown = true,
                help = true,
                typescript = false,
                python = true,
                sh = function()
                    if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
                        -- disable for .env files
                        return false
                    end
                    return true
                end,
            },
            -- should_attach = function(_, bufname)
            -- 	if string.match(bufname, "env") then
            -- 		return false
            -- 	end
            -- 	return true
            -- end,
        }
    end,
}
