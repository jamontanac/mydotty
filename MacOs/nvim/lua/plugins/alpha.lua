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
-- local function capture(cmd, raw)
-- 	local f = assert(io.popen(cmd, "r"))
-- 	local s = assert(f:read("*a"))
-- 	f:close()
-- 	if raw then
-- 		return s
-- 	end
-- 	s = string.gsub(s, "^%s+", "")
-- 	s = string.gsub(s, "%s+$", "")
-- 	s = string.gsub(s, "[\n\r]+", " ")
-- 	return s
-- end
--
-- local function split(source, sep)
-- 	local result, i = {}, 1
-- 	while true do
-- 		local a, b = source:find(sep)
-- 		if not a then
-- 			break
-- 		end
-- 		local candidat = source:sub(1, a - 1)
-- 		if candidat ~= "" then
-- 			result[i] = candidat
-- 		end
-- 		i = i + 1
-- 		source = source:sub(b + 1)
-- 	end
-- 	if source ~= "" then
-- 		result[i] = source
-- 	end
-- 	return result
-- end

return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "VimEnter",
  init = false,
  enabled = true,
  opts = function()
    -- local header_content = read_lines(vim.fn.expand("~/.config/nvim/lua/files/neovim_dashboard.txt"))
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
    -- adding the autocmd group for dynamic header
    vim.api.nvim_create_augroup("alpha_dynamic_header", { clear = true })

    vim.api.nvim_create_autocmd({ "User" }, {
      group = "alpha_dynamic_header",
      pattern = "AlphaReady",
      callback = function()
        if vim.fn.executable("onefetch") == 1 then
          local handle = io.popen("onefetch 2>/dev/null")
          local output = handle:read("*a")
          handle:close()
          output = strip_ansi_codes(output)
          local header = vim.split(output:gsub("\n\n+", "\n"), "\n")
          -- for line in output:gmatch("([^\n]*)\n?") do
          -- 	table.insert(header, line)
          -- end
          if next(header) ~= nil then
            dashboard.section.header.val = header
            pcall(vim.cmd.AlphaRedraw)
            -- require("alpha").redraw()
          end
        end
      end,
      once = true,
    })
    -- vim.api.nvim_create_autocmd({ "User" }, {
    --   group = "alpha_dynamic_header",
    --   pattern = "AlphaReady",
    --   callback = function()
    --     if vim.fn.executable("onefetch") == 1 then
    --       local header = split(
    --         capture(
    --           [[onefetch 2>/dev/null | sed 's/\x1B[@A-Z\\\]^_]\|\x1B\[[0-9:;<=>?]*[-!"#$%&'"'"'()*+,.\/]*[][\\@A-Z^_`a-z{|}~]//g']],
    --           true
    --         ),
    --         "\n"
    --       )
    --       if next(header) ~= nil then
    --         dashboard.section.header.val = header
    --         pcall(vim.cmd.AlphaRedraw)
    --       end
    --     end
    --   end,
    --   once = true,
    -- })
    --
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
