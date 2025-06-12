
return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
    -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
    default_file_explorer = true,
    -- Id is automatically added at the beginning, and name at the end
    -- See :help oil-columns
    columns = {
      -- "permissions",
      "size",
      "mtime",
      "icon",
    },
    -- Buffer-local options to use for oil buffers
    buf_options = {
      buflisted = true,
      bufhidden = "hide",
    },
    -- Window-local options to use for oil buffers
    win_options = {
      wrap = true,
      signcolumn = "yes",
      cursorcolumn = false,
      foldcolumn = "0",
      spell = false,
      list = false,
      conceallevel = 3,
      concealcursor = "nvic",
    },
    -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
    delete_to_trash = true,
    -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    skip_confirm_for_simple_edits = false,
    -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    -- (:help prompt_save_on_select_new_entry)
    prompt_save_on_select_new_entry = true,
    -- Oil will automatically delete hidden buffers after this delay
    -- You can set the delay to false to disable cleanup entirely
    -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
    cleanup_delay_ms = 2000,
    -- Constrain the cursor to the editable parts of the oil buffer
    -- Set to `false` to disable, or "name" to keep it on the file names
    constrain_cursor = "editable",
    -- Set to true to watch the filesystem for changes and reload oil
    -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
    -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
    -- Additionally, if it is a string that matches "actions.<name>",
    -- it will use the mapping at require("oil.actions").<name>
    -- Set to `false` to remove a keymap
    -- See :help oil-actions for a list of all available actions
    keymaps = {
      ["<F2>"] = { "actions.show_help", mode = "n" },
      -- ["<CR>"] = { "actions.select", opts = { tab = true } },
      ["<CR>"] = "actions.select",
      ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"] = { "actions.select", opts = { tab = true } },
      ["<C-p>"] = "actions.preview",
      ["<leader>x"] = { "actions.close", mode = "n" },
      ["<C-l>"] = "actions.refresh",
      -- ["<leader>sf"] = { function() require('oil').toggle_float() end, desc = "Open floating file explorer", mode='n'},
      ["-"] = { "actions.parent", mode = "n" },
      ["_"] = { "actions.open_cwd", mode = "n" },
      ["`"] = { "actions.cd", mode = "n" },
      ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"] = { "actions.change_sort", mode = "n" },
      ["gx"] = "actions.open_external",
      ["g."] = { "actions.toggle_hidden", mode = "n" },
      ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    -- Set to false to disable all of the above keymaps
    use_default_keymaps = false,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
      -- This function defines what is considered a "hidden" file
      is_hidden_file = function(name, bufnr)
        local m = name:match("^%.")
        return m ~= nil
      end,
      -- This function defines what will never be shown, even when `show_hidden` is set
      is_always_hidden = function(name, bufnr)
        return false
      end,
      -- Sort file names with numbers in a more intuitive order for humans.
      -- Can be "fast", true, or false. "fast" will turn it off for large directories.
      natural_order = "fast",
      -- Sort file and directory names case insensitive
      case_insensitive = false,
    },
    
  },
  -- Optional dependencies
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  keys = {
    {'-', '<CMD>Oil<CR>', desc='Open parent directory', silent = true, mode = 'n', noremap = true},
    {'<leader>-',function() require('oil').toggle_float() end, desc='Open/Close a float window to navigate between files', silent = true, mode = 'n'}
  }
}
