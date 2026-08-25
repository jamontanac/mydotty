return {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
        signs = true,
        merge_keywords = true,
        keywords = {
            --     ['@class'] = { icon = '󰠱', color = 'info' },
            --     ['@field'] = { icon = '󰜢', color = 'hint' },
            --     ['@param'] = { icon = '󰏪', color = 'warning', alt = { '@params' } },
            --     ['@return'] = { icon = '󰌑', color = 'default', alt = { '@returns' } },
            --     ['@type'] = { icon = '󰜰', color = 'error' },
            NOTE = { icon = ' ', color = 'hint', alt = { 'INFO', 'NOTE', 'BRIEF' } },
        },
        -- highlight = {
        --     comments_only = true,
        --     pattern = {
        --         [[.*<(KEYWORDS)\s*:]], -- for NOTE:, TODO:, etc.
        --     },
        -- },
    },
}
-- NOTE:
--
-- @param:
--

-- here i have other
-- @return
--
