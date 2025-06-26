return -- Lua
{
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {},
    -- options = { --[[<other options>,]]
    --   'globals',
    -- },
    -- pre_save = function()
    --   vim.api.nvim_exec_autocmds('User', { pattern = 'SessionSavePre' })
    -- end,
}
