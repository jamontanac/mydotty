vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
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
vim.api.nvim_create_autocmd('TermOpen', {
    desc = 'open terminal in nvim',
    group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Store terminal buffer id
local terminal_bufnr = nil

vim.keymap.set('n', '<space>tt', function()
    if terminal_bufnr and vim.fn.bufexists(terminal_bufnr) == 1 then
        -- Terminal buffer exists, check if it's visible
        local win_id = vim.fn.bufwinid(terminal_bufnr)
        if win_id ~= -1 then
            -- Terminal is visible, hide it
            vim.api.nvim_win_hide(win_id)
        else
            -- Terminal exists but is hidden, show it
            vim.cmd.vsplit()
            vim.cmd.wincmd 'J'
            -- Use pcall to safely try switching to the buffer
            local success = pcall(vim.cmd, 'buffer ' .. terminal_bufnr)
            if success then
                vim.api.nvim_win_set_height(0, 7)
            else
                -- Buffer doesn't actually exist, reset and create new one
                terminal_bufnr = nil
                vim.cmd.term()
                vim.cmd.wincmd 'J'
                vim.api.nvim_win_set_height(0, 7)
                terminal_bufnr = vim.api.nvim_get_current_buf()
            end
        end
    else
        -- No terminal exists, create new one
        vim.cmd.vnew()
        vim.cmd.term()
        vim.cmd.wincmd 'J'
        vim.api.nvim_win_set_height(0, 7)
        -- Store the new terminal buffer id
        terminal_bufnr = vim.api.nvim_get_current_buf()
    end
end)
