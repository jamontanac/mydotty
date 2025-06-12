
return { 'rose-pine/neovim', 
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      local rosepine = require('rose-pine')
      rosepine.setup({
        variant = 'auto',
        dark_variant = 'moon',
        disable_background = true,
        disable_float_background = true,
        extend_background_behind_borders = true,

        enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true, -- Handle deprecated options automatically
        },

        styles = {
            bold = true,
            italic = true,
            transparency = false,
        },

        groups = {
            border = "muted",
            link = "iris",
            panel = "surface",

            error = "love",
            hint = "iris",
            info = "foam",
            note = "pine",
            todo = "rose",
            warn = "gold",

            git_add = "foam",
            git_change = "rose",
            git_delete = "love",
            git_dirty = "rose",
            git_ignore = "muted",
            git_merge = "iris",
            git_rename = "pine",
            git_stage = "iris",
            git_text = "rose",
            git_untracked = "subtle",

            h1 = "iris",
            h2 = "foam",
            h3 = "rose",
            h4 = "gold",
            h5 = "pine",
            h6 = "foam",
        },



      })
      -- enable the theme
    local bg_transparent = true

    local toggle_transparency = function()
        bg_transparent = not bg_transparent
        rosepine.setup({
          -- transparent_background = bg_transparent,
          disable_background = bg_transparent,
          disable_float_background = bg_transparent,
          extend_background_behind_borders = bg_transparent,
        })
        vim.cmd('colorscheme rose-pine')
        print('Rose Pine background transparency toggled: ' .. tostring(bg_transparent))
    end
    vim.keymap.set('n','<leader>bg', toggle_transparency, {noremap = true, silent = true})
    vim.cmd('colorscheme rose-pine')
    end
}
