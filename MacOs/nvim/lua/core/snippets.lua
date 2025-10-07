-- somewhere early (e.g., lua/core/keymaps.lua)
vim.api.nvim_create_user_command('StartPresentation', function()
    local present = require 'plugins.present'
    present.setup()

    present.start_presentation { author = 'Jose Montaña' } -- now call this on the module
    -- match your actual module path
end, { desc = 'Start Presentation Mode' })

vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        -- vim.highlight.on_yank { higroup = 'IncSearch', timeout = 150 }
        vim.hl.on_yank()
    end,
})

-- makes * and # work on visual mode too.
vim.api.nvim_exec(
    [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]],
    false
)

local filetype_vim = vim.api.nvim_create_augroup('filetype_vim', { clear = true })
--
-- Vim filetype: foldmethod=marker
vim.api.nvim_create_autocmd('FileType', {
    group = filetype_vim,
    pattern = 'vim',
    command = 'setlocal foldmethod=marker',
})
-- For JSON and YAML
vim.api.nvim_create_autocmd('FileType', {
    group = filetype_vim,
    pattern = { 'json', 'yaml' },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
        vim.opt_local.foldmethod = 'indent'
    end,
})

vim.filetype.add {
    extension = {
        h = 'cpp',
        tpp = 'cpp',
        cu = 'cuda',
    },
}
-- Setting up the env variables from the .env file
local function load_env_file(filepath)
    local file = io.open(filepath, 'r')
    if not file then
        vim.notify('.env file not found at ' .. filepath, vim.log.levels.WARN)
        return
    end

    for line in file:lines() do
        -- Ignore comments and blank lines
        if not line:match '^%s*#' and line:match '=' then
            local key, value = line:match '^%s*([%w_]+)%s*=%s*(.*)%s*$'
            if key and value then
                vim.env[key] = value
            end
        end
    end
    file:close()
    -- vim.notify('.env loaded from ' .. filepath)
end

-- Call this function in your config to load ~/.env
load_env_file(vim.fn.expand '~/.env')
