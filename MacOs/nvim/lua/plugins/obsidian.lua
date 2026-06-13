local function resolve_templates_folder()
    local env_templates = os.getenv 'OBSIDIAN_TEMPLATES'
    if env_templates and env_templates ~= '' then
        local expanded = vim.fn.expand(env_templates)
        if vim.fn.isdirectory(expanded) == 1 then
            return expanded
        end
    end

    local repo_templates = vim.fn.expand '~/mydotty/MacOs/nvim/templates'
    if vim.fn.isdirectory(repo_templates) == 1 then
        return repo_templates
    end

    local config_templates = vim.fn.expand '~/.config/nvim/templates'
    if vim.fn.isdirectory(config_templates) == 1 then
        return config_templates
    end

    return nil
end

local function build_workspaces()
    local workspaces = {}
    local env_vault = os.getenv 'OBSIDIAN_VAULT'
    local default_vault = vim.fn.expand '~/vaults/personal'
    local templates_folder = resolve_templates_folder()

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
                folder = templates_folder,
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
            time_format = '%H:%M',
            template = 'daily.md',
        },
        templates = {
            folder = resolve_templates_folder(),
            date_format = '%Y-%m-%d',
            time_format = '%H:%M',
            substitutions = {
                subject = function()
                    local value = vim.fn.input 'Subject (optional): '
                    if not value then
                        return ''
                    end

                    return vim.trim(value)
                end,
                -- daily_title = function()
                --     local value = vim.fn.input 'Daily title (optional): '
                --     if not value then
                --         return ''
                --     end

                --     return vim.trim(value)
                -- end,
            },
        },
        callbacks = {
            enter_note = function()
                vim.keymap.set('x', '<leader>ol', ':ObsidianLink<CR>', {
                    buffer = true,
                    desc = 'Obsidian link selection to existing note',
                })
                vim.keymap.set('x', '<leader>oL', ':ObsidianLinkNew<CR>', {
                    buffer = true,
                    desc = 'Obsidian link selection to new note',
                })
            end,
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
            ['<leader>oq'] = {
                action = '<cmd>ObsidianQuickSwitch<CR>',
                opts = { buffer = true, desc = 'Obsidian quick switch' },
            },
            ['<leader>ob'] = {
                action = '<cmd>ObsidianBacklinks<CR>',
                opts = { buffer = true, desc = 'Obsidian backlinks' },
            },
        },
    },
}