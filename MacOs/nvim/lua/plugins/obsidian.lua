local function build_workspaces()
    local workspaces = {}
    local env_vault = os.getenv 'OBSIDIAN_VAULT'
    local default_vault = vim.fn.expand '~/vaults/personal'

    -- Set $OBSIDIAN_VAULT to point to your preferred vault root.
    if env_vault and env_vault ~= '' then
        table.insert(workspaces, {
            name = 'personal',
            path = vim.fn.expand(env_vault),
        })
    elseif vim.fn.isdirectory(default_vault) == 1 then
        table.insert(workspaces, {
            name = 'personal',
            path = default_vault,
        })
    end

    table.insert(workspaces, {
        name = 'notes',
        path = function()
            return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        end,
        overrides = {
            notes_subdir = vim.NIL,
            new_notes_location = 'current_dir',
            templates = {
                folder = vim.NIL,
            },
            disable_frontmatter = true,
        },
    })

    return workspaces
end

return {
    'epwalsh/obsidian.nvim',
    version = '*',
    lazy = true,
    ft = 'markdown',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    opts = {
        ui = {
            enable = false,
        },
        workspaces = build_workspaces(),
        completion = {
            nvim_cmp = false,
            min_chars = 2,
        },
        picker = {
            name = 'telescope.nvim',
        },
        notes_subdir = 'notes',
        new_notes_location = 'notes_subdir',
        daily_notes = {
            folder = 'notes/dailies',
            date_format = '%Y-%m-%d',
        },
        templates = {
            folder = 'templates',
            date_format = '%Y-%m-%d',
            time_format = '%H:%M',
        },
        attachments = {
            img_folder = 'assets/imgs',
        },
        mappings = {
            ['gf'] = {
                action = function()
                    return require('obsidian').util.gf_passthrough()
                end,
                opts = { noremap = false, expr = true, buffer = true, desc = 'Obsidian follow link' },
            },
            ['<leader>ch'] = {
                action = function()
                    return require('obsidian').util.toggle_checkbox()
                end,
                opts = { buffer = true, desc = 'Obsidian toggle checkbox' },
            },
            ['<leader>on'] = {
                action = '<cmd>ObsidianNewFromTemplate<CR>',
                opts = { buffer = true, desc = 'Obsidian new note from template' },
            },
            ['<leader>od'] = {
                action = '<cmd>ObsidianToday<CR>',
                opts = { buffer = true, desc = "Obsidian today's daily note" },
            },
        },
    },
}