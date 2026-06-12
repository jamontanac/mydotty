return {
    'iamcco/markdown-preview.nvim',
    ft = { 'markdown' },
    cmd = {
        'MarkdownPreviewToggle',
        'MarkdownPreview',
        'MarkdownPreviewStop',
    },
    build = 'cd app && npm install',
    init = function()
        -- Keep this plugin browser-only and markdown-scoped.
        vim.g.mkdp_filetypes = { 'markdown' }
        vim.g.mkdp_command_for_global = 0
        vim.g.mkdp_auto_start = 0
        vim.g.mkdp_auto_close = 1
        vim.g.mkdp_open_to_the_world = 0
        vim.g.mkdp_echo_preview_url = 1
        vim.g.mkdp_refresh_slow = 0
        vim.g.mkdp_combine_preview = 0
    end,
    keys = {
        {
            '<leader>sp',
            '<cmd>MarkdownPreviewToggle<CR>',
            ft = 'markdown',
            desc = '[S]how [p]review browser markdown',
        },
        {
            '<leader>Sp',
            '<cmd>MarkdownPreviewStop<CR>',
            ft = 'markdown',
            desc = '[S]top [p]review browser markdown ',
        },
    },
}
