--
-- +-----------------------+
-- |  Static Header File   |
-- | (dashboard_custom_    |
-- | header.txt)           |
-- +----------+------------+
--            |
--            v
-- +----------+------------+
-- |  Alpha Dashboard      |
-- |  Initial Setup        |
-- +----------+------------+
--            |
--            v
-- +----------+------------+  Yes +-----------------+
-- |  In Git Repository? +------->+ Generate Dynamic |
-- +----------+------------+      | Header with      |
--            |                   | onefetch         |
--            | No                +-----------------+
--            v
-- +----------+------------+
-- |  Keep Static Header   |
-- +-----------------------+

local function read_lines(filepath)
  local lines = {}
  local file = io.open(filepath, "r")
  if file then
    for line in file:lines() do
      table.insert(lines, line)
    end
    file:close()
  end
  return lines
end

local function strip_ansi_codes(s)
  return s:gsub("[\27\155][][()#;?%d]*[0-9A-Za-z]", "")
end

return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VimEnter",
  init = false,
  enabled = true,
  opts = function()
    local static_header_content = read_lines(vim.fn.expand("~/.config/nvim/lua/files/wave_dashboard.txt"))

    local dashboard = require("alpha.themes.dashboard")

    -- dashboard.section.header.val = vim.split(logo, "\n") -- stylua: ignore
    dashboard.section.header.val = static_header_content
    dashboard.section.buttons.val = {
      -- dashboard.button("f", " " .. " Find file", "<cmd> lua LazyVim.pick()() <cr>"),
      dashboard.button("f", " " .. " Find file", "<cmd>Telescope find_files<CR>"),
      dashboard.button("n", " " .. " New file", [[<cmd> ene <BAR> startinsert <cr>]]),
      dashboard.button("r", " " .. " Recent files", [[<cmd>Telescope oldfiles<cr>]]),
      -- dashboard.button("r", " " .. " Recent files", function()require("lazyvim.util").picker("oldfiles")() end),
      dashboard.button("g", " " .. " Find text", [[<cmd>Telescope live_grep<cr>]]),
      dashboard.button("b", " " .. " Jump to bookmarks", ":Telescope marks<CR>"),
      -- dashboard.button("g", " " .. " Find text", [[<cmd> lua LazyVim.pick("live_grep")() <cr>]]),
      dashboard.button("c", " " .. " Config", function()
        require("telescope.builtin").find_files({
          cwd = vim.fn.stdpath("config"),
          file_ignore_patterns = { "backup" },
        })
      end),
      dashboard.button("s", " " .. " Restore Session", [[<cmd> lua require("persistence").load() <cr>]]),
      -- dashboard.button("x", " " .. " Lazy Extras", "<cmd> LazyExtras <cr>"),
      dashboard.button("l", "󰒲 " .. " Lazy", "<cmd> Lazy <cr>"),
      dashboard.button("q", " " .. " Quit", "<cmd> qa <cr>"),
    }
    for _, button in ipairs(dashboard.section.buttons.val) do
      button.opts.hl = "AlphaButtons"
      button.opts.hl_shortcut = "AlphaShortcut"
    end
    dashboard.section.header.opts.hl = "AlphaHeader"
    dashboard.section.buttons.opts.hl = "AlphaButtons"
    dashboard.section.footer.opts.hl = "AlphaFooter"
    -- dashboard.opts.layout[1].val = 8
    return dashboard
  end,
  config = function(_, dashboard)
    -- close Lazy and re-open when the dashboard is ready
    if vim.o.filetype == "lazy" then
      vim.cmd.close()
      vim.api.nvim_create_autocmd("User", {
        once = true,
        pattern = "AlphaReady",
        callback = function()
          require("lazy").show()
        end,
      })
    end

    require("alpha").setup(dashboard.opts)
    local static_header = dashboard.section.header.val
    -- require("alpha").setup(dashboard.opts)
    -- adding the autocmd group for dynamic header
    vim.api.nvim_create_augroup("alpha_dynamic_header", { clear = true })

    vim.api.nvim_create_autocmd({ "User" }, {
      group = "alpha_dynamic_header",
      pattern = "AlphaReady",
      callback = function()
        if vim.fn.executable("onefetch") == 1 then
          -- Check if we're in a Git repo first
          local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
          local is_git = handle:read("*a") ~= ""
          handle:close()

          if is_git then
            local handle = io.popen("onefetch 2>/dev/null")
            local output = handle:read("*a")
            handle:close()
            output = strip_ansi_codes(output)
            local header = vim.split(output:gsub("\n\n+", "\n"), "\n")
            if #header > 3 then -- Ensure valid onefetch output
              dashboard.section.header.val = header
              pcall(vim.cmd.AlphaRedraw)
            end
          else
            dashboard.section.header.val = static_header
            pcall(vim.cmd.AlphaRedraw)
          end
        end
      end,
      once = true,
    })

    --
    -- vim.api.nvim_create_autocmd({ "User" }, {
    --   group = "alpha_dynamic_header",
    --   pattern = "AlphaReady",
    --   callback = function()
    --     if vim.fn.executable("onefetch") == 1 then
    --       -- Check if we're in a Git repo first
    --       local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
    --       local is_git = handle:read("*a") ~= ""
    --       local handle = io.popen("onefetch 2>/dev/null")
    --       local output = handle:read("*a")
    --       handle:close()
    --       output = strip_ansi_codes(output)
    --       local header = vim.split(output:gsub("\n\n+", "\n"), "\n")
    --       if next(header) ~= nil then
    --         dashboard.section.header.val = header
    --         pcall(vim.cmd.AlphaRedraw)
    --       end
    --     end
    --   end,
    --   once = true,
    -- })
    vim.api.nvim_create_autocmd("User", {
      once = true,
      pattern = "LazyVimStarted",
      callback = function()
        local footer_content = read_lines(vim.fn.expand("~/.config/nvim/lua/files/footer.txt"))
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

        local stats_line = "⚡ Neovim loaded "
            .. stats.loaded
            .. "/"
            .. stats.count
            .. " plugins in "
            .. ms
            .. "ms"
        local footer = { stats_line }
        for _, line in ipairs(footer_content) do
          table.insert(footer, line)
        end
        dashboard.section.footer.val = footer
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}

-- return {
--   'nvimdev/dashboard-nvim',
--   lazy=false,
--   event = 'VimEnter',
--   opts = function()
--     require('dashboard').setup {
--       -- config
--     }
--   end,
--   dependencies = { {'nvim-tree/nvim-web-devicons'}}
-- }
