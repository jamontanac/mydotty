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

local function slugify_note_title(title)
    local slug = title:lower()
    slug = slug:gsub('%s+', '-')
    slug = slug:gsub('[^a-z0-9-]', '')
    slug = slug:gsub('%-+', '-')
    slug = slug:gsub('^%-', '')
    slug = slug:gsub('%-$', '')
    return slug
end

local function normalize_selection_label(selection)
    local label = selection:gsub('%s*\n%s*', ' ')
    label = label:gsub('%s+', ' ')
    return vim.trim(label)
end

local MAX_NEW_NOTE_TITLE_CHARS = 96

local function clamp_note_title_for_path(title)
    local trimmed = vim.trim(title or '')
    if trimmed == '' then
        return ''
    end

    if vim.fn.strchars(trimmed) <= MAX_NEW_NOTE_TITLE_CHARS then
        return trimmed
    end

    local shortened = vim.fn.strcharpart(trimmed, 0, MAX_NEW_NOTE_TITLE_CHARS)
    return vim.trim(shortened)
end

local function replace_visual_selection(bufnr, viz, text)
    local start_row = math.max(viz.csrow - 1, 0)
    local end_row = math.max(viz.cerow - 1, 0)

    local start_col = math.max(viz.cscol - 1, 0)
    local end_line = vim.api.nvim_buf_get_lines(bufnr, end_row, end_row + 1, false)[1] or ''
    local end_col = math.min(math.max(viz.cecol, 0), #end_line)

    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, { text })
end

local function get_visual_selection_for_link()
    local util = require 'obsidian.util'
    local viz = util.get_visual_selection { strict = true }
    if not viz then
        vim.notify('Use visual mode to select text before linking', vim.log.levels.WARN)
        return nil, nil
    end

    local label = normalize_selection_label(viz.selection or '')
    if label == '' then
        vim.notify('Selection is empty', vim.log.levels.WARN)
        return nil, nil
    end

    return viz, label
end

local function link_visual_selection_to_existing_note()
    local obsidian = require 'obsidian'
    local client = obsidian.get_client()
    local viz, label = get_visual_selection_for_link()
    if not viz then
        return
    end

    local picker = client:picker()
    if not picker then
        vim.notify('No picker configured for obsidian.nvim', vim.log.levels.ERROR)
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    picker:find_notes {
        prompt_title = 'Select note to link',
        callback = function(path)
            local selected_path = type(path) == 'string' and path or tostring(path)

            client:resolve_note_async(selected_path, function(...)
                local note = select(1, ...)
                if not note then
                    vim.notify('Could not resolve selected note', vim.log.levels.WARN)
                    return
                end

                vim.schedule(function()
                    if not vim.api.nvim_buf_is_valid(bufnr) then
                        return
                    end

                    replace_visual_selection(bufnr, viz, client:format_link(note, { label = label }))
                    client:update_ui()
                end)
            end)
        end,
    }
end

local function link_visual_selection_to_new_note()
    local obsidian = require 'obsidian'
    local client = obsidian.get_client()
    local viz, label = get_visual_selection_for_link()
    if not viz then
        return
    end

    local default_title = clamp_note_title_for_path(label)
    local raw_title = vim.fn.input('New note title: ', default_title)
    local typed_title = vim.trim(raw_title or '')
    local title = typed_title == '' and default_title or typed_title
    title = clamp_note_title_for_path(title)

    if title == '' then
        vim.notify('Title is required to create a new note', vim.log.levels.WARN)
        return
    end

    local ok, note_or_err = pcall(function()
        return client:create_note { title = title }
    end)
    if not ok then
        vim.notify(string.format('Failed to create note: %s', note_or_err), vim.log.levels.ERROR)
        return
    end

    local note = note_or_err
    local bufnr = vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end

    replace_visual_selection(bufnr, viz, client:format_link(note, { label = label }))
    client:update_ui()
end

local function map_visual_obsidian_command(lhs, handler, desc)
    vim.keymap.set('x', lhs, handler, {
        buffer = true,
        desc = desc,
        silent = true,
    })
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
        note_id_func = function(title)
            local date_prefix = os.date '%Y-%m-%d'

            if not title or vim.trim(title) == '' then
                return date_prefix
            end

            local slug = slugify_note_title(vim.trim(title))
            if slug == '' then
                return date_prefix
            end

            return string.format('%s-%s', date_prefix, slug)
        end,
        note_path_func = function(spec)
            local path = (spec.dir / tostring(spec.id)):with_suffix '.md'
            if not path:exists() then
                return path
            end

            -- Avoid collisions when creating multiple notes with the same title on the same day.
            return (spec.dir / string.format('%s-%s', tostring(spec.id), os.date '%H%M%S')):with_suffix '.md'
        end,
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

                map_visual_obsidian_command('<leader>ol', link_visual_selection_to_existing_note, 'Obsidian link selection to existing note')
                map_visual_obsidian_command('<leader>oL', link_visual_selection_to_new_note, 'Obsidian new link selection to new note')
            --    vim.keymap.set('x', '<leader>ol', ':ObsidianLink<CR>', {
            --         buffer = true,
            --         desc = 'Obsidian link selection to existing note',
            --     })
            --     vim.keymap.set('x', '<leader>oL', ':ObsidianLinkNew<CR>', {
            --         buffer = true,
            --         desc = 'Obsidian link selection to new note',
            --     }) 
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
            ['<leader>ont'] = {
                action = '<cmd>ObsidianNewFromTemplate<CR>',
                opts = { buffer = true, desc = 'Obsidian new note from template' },
            },
            ['<leader>onn'] = {
                action = function()
                    local obsidian = require 'obsidian'
                    local util = require 'obsidian.util'

                    local client = obsidian.get_client()
                    local raw_title = util.input 'Enter note title: '
                    if raw_title == nil then
                        return
                    end

                    local title = vim.trim(raw_title)
                    if title == '' then
                        vim.notify('Title is required for <leader>onn', vim.log.levels.WARN)
                        return
                    end

                    local note = client:create_note { title = title, no_write = true }
                    client:open_note(note, { sync = true })
                    client:write_note_to_buffer(note, { template = 'note.md' })
                end,
                opts = { buffer = true, desc = 'Obsidian new note from note template' },
            },
            ['<leader>onN'] = {
                action = '<cmd>ObsidianNew<CR>',
                opts = { buffer = true, desc = 'Obsidian new note' },
            },
            ['<leader>ond'] = {
                action = '<cmd>ObsidianToday<CR>',
                opts = { buffer = true, desc = "Obsidian new today's daily note" },
            },
            ['<leader>oc'] = {
                action = '<cmd>ObsidianQuickSwitch<CR>',
                opts = { buffer = true, desc = 'Obsidian quick switch' },
            },
            -- ['<leader>op'] = {
            --     action = '<cmd>b#<CR>',
            --     opts = { buffer = true, desc = 'Obsidian previous buffer' },
            -- },
            ['<leader>ob'] = {
                action = '<cmd>ObsidianBacklinks<CR>',
                opts = { buffer = true, desc = 'Obsidian backlinks' },
            },
        },
    },
}