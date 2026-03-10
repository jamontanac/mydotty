# AGENTS.md - Neovim Configuration Guide

> Comprehensive guide for AI coding agents working in this Neovim configuration repository

## Project Overview

This is a **Neovim configuration repository** using:

- **Plugin Manager**: lazy.nvim
- **Primary Language**: Lua (configuration)
- **Supported Languages**: Python, Rust, Julia, JavaScript, TypeScript, Bash, C/C++, Go, and more
- **Architecture**: Modular plugin-based structure
- **Location**: `~/.config/nvim` (not a git repository)

---

## Commands Reference

### Neovim Operations

```vim
:source $MYVIMRC           " Reload configuration
:Lazy                      " Open plugin manager UI
:Lazy sync                 " Update/install all plugins
:Lazy reload <plugin>      " Reload specific plugin
:Lazy clean                " Remove unused plugins
:checkhealth               " Verify Neovim health
:messages                  " View messages/errors log
```

### Formatting & LSP

```vim
<leader>f                  " Format current buffer
<leader>wf                 " Save without formatting
[d / ]d                    " Navigate to prev/next diagnostic
<leader>d                  " Show diagnostic float window
<leader>q                  " Open diagnostic quickfix list
grn                        " LSP rename symbol
gra                        " LSP code action
grd                        " Go to definition
grr                        " Show references
gri                        " Go to implementation
grt                        " Go to type definition
```

### AI Tools (CodeCompanion)

```vim
" Main commands
<leader>aa                 " Actions picker (Telescope)
<leader>ac                 " Chat sidebar (persistent)
<leader>af                 " Chat floating (70%, <Esc> to close)
<leader>ai                 " Inline assistant
<leader>aq                 " Quick question

" Visual mode actions
<leader>ap                 " Add selection to chat
<leader>ae                 " Explain selected code
<leader>ar                 " Review selected code
<leader>ax                 " Fix selected code

" Copilot completions (automatic via blink.cmp)
<C-y>                      " Accept completion
<C-n>/<C-p>                " Next/previous completion
```

---

## Code Style Guidelines

### Lua Formatting (stylua.toml)

**Core Rules**:

- **Indentation**: 2 spaces
- **Quotes**: Single quotes preferred (`'string'` not `"string"`)
- **Call Parentheses**: Omit for string/table literals (`print 'hello'` not `print('hello')`)
- **Sort Requires**: Enabled (alphabetical)

**Examples**:

```lua
-- ✅ GOOD
local M = {}
local plenary = require 'plenary'
local utils = require 'core.utils'

function M.setup(opts)
  opts = opts or {}
  vim.notify 'Plugin loaded'
end

return M

-- ❌ BAD
local M={}
local utils = require("core.utils")
local plenary = require 'plenary'

function M.setup( opts )
    opts = opts or {}
    vim.notify("Plugin loaded")
end

return M
```

### File Structure

```
.
├── init.lua                      # Entry point - loads core and plugins
├── stylua.toml                   # Lua formatter configuration
├── lazy-lock.json                # Plugin version lock (auto-generated)
├── lua/
│   ├── core/
│   │   ├── options.lua           # Vim options (indentation, UI, etc.)
│   │   ├── keymaps.lua           # Global keybindings
│   │   └── snippets.lua          # Custom snippets and autocmds
│   └── plugins/
│       ├── lsp.lua               # LSP configuration
│       ├── autoformatter.lua     # Formatter configuration
│       ├── autocompletion.lua    # Completion (blink.cmp + copilot)
│       ├── codecompanion.lua     # AI chat assistant
│       ├── telescope.lua         # Fuzzy finder
│       ├── treesitter.lua        # Syntax highlighting
│       └── *.lua                 # Other plugin configs
└── plugins/                      # Custom plugins
    ├── floating-terminal/        # Custom terminal plugin
    └── present/                  # Custom presentation plugin
```

### Plugin Configuration Pattern

All plugins in `lua/plugins/` follow the **lazy.nvim** structure:

```lua
-- lua/plugins/example.lua
return {
  'author/plugin-name',
  version = '*',                   -- Optional: version constraint
  dependencies = {                 -- Optional: other required plugins
    'other/plugin',
  },
  event = 'VeryLazy',              -- Optional: lazy load on event
  cmd = { 'PluginCommand' },       -- Optional: lazy load on command
  keys = {                         -- Optional: lazy load on keymap
    { '<leader>x', '<cmd>Cmd<cr>', desc = 'Description' },
  },

  -- Simple configuration (automatically calls setup())
  opts = {
    option = value,
  },

  -- OR advanced configuration
  config = function()
    require('plugin-name').setup {
      option = value,
    }
  end,
}
```

### Naming Conventions

- **Variables/Functions**: `snake_case` (e.g., `local my_function`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `local MAX_WIDTH = 100`)
- **Modules**: `snake_case` matching filename (e.g., `lua/core/utils.lua` → `require 'core.utils'`)
- **Private functions**: Prefix with `_` (e.g., `local function _helper()`)

### Import/Require Conventions

```lua
-- Core/library modules first, sorted alphabetically
local api = vim.api
local fn = vim.fn
local plenary = require 'plenary'

-- Local modules second
local config = require 'core.config'
local utils = require 'core.utils'

-- Constants
local MAX_WIDTH = 100

-- Module table
local M = {}

-- ... implementation ...

return M
```

### Error Handling

**Always use `pcall` for potentially failing operations**:

```lua
-- ✅ GOOD - Safe plugin loading
local ok, telescope = pcall(require, 'telescope')
if not ok then
  vim.notify('Telescope not installed', vim.log.levels.WARN)
  return
end

-- ✅ GOOD - Safe API calls
local success, result = pcall(vim.api.nvim_buf_get_lines, bufnr, 0, -1, false)
if not success then
  vim.notify('Failed to read buffer', vim.log.levels.ERROR)
  return
end

-- ❌ BAD - Will crash if plugin not installed
local telescope = require 'telescope'
```

### Autocommands

**Always create augroups with `clear = true`**:

```lua
local augroup = vim.api.nvim_create_augroup('MyPluginGroup', { clear = true })

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup,
  pattern = '*.lua',
  callback = function()
    -- Do something before saving
  end,
  desc = 'Format Lua files on save',
})
```

### Keymaps

**Always include descriptive `desc` parameter**:

```lua
vim.keymap.set('n', '<leader>x', '<cmd>close<cr>', {
  desc = 'Close current window',
  noremap = true,
  silent = true,
})

-- For plugin-specific keymaps, include buffer parameter
vim.keymap.set('n', 'q', '<cmd>quit<cr>', {
  buffer = bufnr,
  desc = 'Quit floating window',
})
```

---

## LSP & Formatting

### Installed LSP Servers (via mason-lspconfig)

- **Lua**: `lua_ls` - Lua language server
- **Python**: `pyright` (types), `ruff` (linting/formatting)
- **Rust**: `rust_analyzer`
- **Julia**: `julials`
- **JavaScript/TypeScript**: `ts_ls` (available but not default)
- **Bash**: `bashls`
- **Docker**: `dockerls`, `docker_compose_language_service`
- **Infrastructure**: `terraformls`, `yamlls`, `jsonls`, `sqlls`
- **C/C++**: `clangd`

### Formatters (via conform.nvim)

| Language              | Formatter      | Indent   | Notes                         |
| --------------------- | -------------- | -------- | ----------------------------- |
| Lua                   | stylua         | 2 spaces | Single quotes, no call parens |
| Python                | ruff           | 4 spaces | Linting + formatting          |
| JavaScript/TypeScript | prettier       | 2 spaces |                               |
| HTML/CSS              | prettier       | 2 spaces |                               |
| JSON                  | jq             | 4 spaces |                               |
| YAML                  | prettier       | 4 spaces |                               |
| Markdown              | prettier       | 2 spaces |                               |
| Shell (bash/sh)       | shfmt          | 2 spaces |                               |
| Terraform             | terraform_fmt  | 2 spaces |                               |
| C/C++                 | clang-format   | 2 spaces |                               |
| Julia                 | juliaformatter | 4 spaces |                               |
| Rust                  | rustfmt        | 4 spaces |                               |

**Behavior**:

- Format on save: **Enabled** by default
- Save without formatting: `<leader>wf`
- Manual format: `<leader>f`

---

## AI Tools Integration

### Tool Comparison

| Tool              | Purpose                  | Keybindings    | Model  | Integration |
| ----------------- | ------------------------ | -------------- | ------ | ----------- |
| **Copilot**       | Inline completions       | Auto + `<C-y>` | gpt-4o | blink.cmp   |
| **CodeCompanion** | Chat, questions, reviews | `<leader>a*`   | gpt-4o | Standalone  |

### When to Use Each Tool

**Copilot (Inline Completions)**:

- Writing new code from scratch
- Autocompleting function calls
- Generating boilerplate
- Completing patterns (loops, conditionals)

**CodeCompanion Sidebar** (`<leader>ac`):

- Long conversations
- Complex architectural questions
- Multi-step problem solving
- Code reviews of multiple files

**CodeCompanion Floating** (`<leader>af`):

- Quick questions ("How do I...?")
- One-off explanations
- Fast code reviews
- Distraction-free quick help

**CodeCompanion Inline** (`<leader>ai`):

- Direct AI edits with diff view
- Refactoring selected code
- Quick fixes with context

### CodeCompanion Quick Actions

**Visual Mode Shortcuts**:

```vim
" Select code in visual mode, then:
<leader>ae    " Explain: Get clear explanation of selected code
<leader>ar    " Review: Check for bugs, performance, best practices
<leader>ax    " Fix: AI fixes issues and returns corrected code
<leader>ap    " Add: Add selection to ongoing chat conversation
```

**Chat Commands** (in chat window):

```
/buffer       " Include a buffer in context (uses Telescope)
/file         " Include a file in context (uses Telescope)
/help         " Show available slash commands
```

### Model Configuration

**Current**: `gpt-4o` (latest GPT-4 Optimized)
**Future**: Configuration ready for `gpt-5-codex` when available

To update model, edit `lua/plugins/codecompanion.lua`:

```lua
schema = {
  model = {
    default = 'gpt-4o',  -- Change this line when new models available
  },
},
```

---

## Common Patterns

### Adding a New Plugin

1. **Create plugin file**: `lua/plugins/<plugin-name>.lua`
2. **Use lazy.nvim structure**:
   ```lua
   return {
     'author/plugin',
     opts = { ... },
   }
   ```
3. **Update init.lua** (if not auto-loaded):
   ```lua
   require 'plugins.<plugin-name>',
   ```
4. **Install**: `:Lazy sync`
5. **Reload**: Restart Neovim or `:Lazy reload <plugin>`

### Telescope Integration

Telescope is the primary fuzzy finder:

```lua
local builtin = require 'telescope.builtin'

builtin.find_files()              -- Find files
builtin.live_grep()               -- Search in files
builtin.buffers()                 -- List open buffers
builtin.help_tags()               -- Search help
builtin.lsp_references()          -- LSP references
builtin.diagnostics()             -- LSP diagnostics
```

**Keybindings**:

```vim
<leader>sf    " Search files
<leader>sg    " Search grep (live)
<leader>sw    " Search word under cursor
<leader>sd    " Search diagnostics
<leader>sh    " Search help
<leader><leader>  " Search buffers
```

### Creating Floating Windows

Reference: `lua/plugins/present/init.lua` for complete example

```lua
-- Create buffer
local buf = vim.api.nvim_create_buf(false, true)

-- Calculate centered position
local width = math.floor(vim.o.columns * 0.7)
local height = math.floor(vim.o.lines * 0.7)
local row = math.floor((vim.o.lines - height) / 2)
local col = math.floor((vim.o.columns - width) / 2)

-- Open floating window
local win = vim.api.nvim_open_win(buf, true, {
  relative = 'editor',
  width = width,
  height = height,
  row = row,
  col = col,
  border = 'rounded',  -- 'none', 'single', 'double', 'rounded', 'solid', 'shadow'
  style = 'minimal',
})

-- Set buffer content
vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'Line 1', 'Line 2' })

-- Add keymap to close with <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', {
  buffer = buf,
  desc = 'Close floating window',
})
```

### Testing Configuration Changes

**Scenario 1: Modified single plugin** (`lua/plugins/example.lua`)

```vim
:Lazy reload example
" or
:Lazy sync
```

**Scenario 2: Modified core settings** (`lua/core/options.lua`)

```vim
:source $MYVIMRC
" or restart Neovim
```

**Scenario 3: Added new plugin**

```vim
:Lazy sync
" then restart Neovim
```

**Verify no errors**:

```vim
:checkhealth
:messages
:LspInfo        " For LSP issues
:ConformInfo    " For formatter issues
```

---

## Important Notes

### Files to Never Edit Manually

- `lazy-lock.json` - Auto-generated by lazy.nvim
- `backup/` directory - Neovim's automatic backups

### Indentation Standards

| File Type             | Spaces | Notes            |
| --------------------- | ------ | ---------------- |
| Lua                   | 2      | Via stylua       |
| JSON                  | 4      | Via jq           |
| YAML                  | 4      | Via prettier     |
| Python                | 4      | Via ruff (PEP 8) |
| JavaScript/TypeScript | 2      | Via prettier     |
| All others            | 2      | Default          |

### Special Keybindings

**Leader Key**: `<Space>`

**Core Navigation**:

- `jk` or `jj` - Exit insert mode
- `<C-h/j/k/l>` - Navigate between windows
- `<C-u/d>` - Scroll up/down (centered)
- `<A-j/k>` - Move lines/selection up/down

**Window Management**:

- `<leader>x` - Close current buffer
- `<leader>c` - Close current window
- `<C-q>` - Quit Neovim

---

## Future Enhancements

### MCP (Model Context Protocol)

**Status**: Disabled (ready to enable)

MCP allows AI to interact with external tools (filesystem, git, databases, etc.)

**To Enable**:

1. Uncomment in `lua/plugins/codecompanion.lua`:
   ```lua
   dependencies = {
     -- ... other deps ...
     'ravitemer/mcphub.nvim',  -- Uncomment this line
   },
   ```
2. Uncomment and configure MCP section:
   ```lua
   mcp = {
     enabled = true,
     servers = {
       filesystem = {
         command = 'npx',
         args = { '-y', '@modelcontextprotocol/server-filesystem', vim.fn.expand '~' },
       },
     },
   },
   ```
3. Run `:Lazy sync`
4. Restart Neovim

**Useful MCP Servers**:

- **Filesystem**: Browse/edit files via AI
- **Git**: Git operations and history queries
- **Python**: Package and environment queries
- **Database**: SQL queries and schema inspection
- **Web**: Fetch and parse web content

---

## Troubleshooting

### CodeCompanion Issues

**Problem**: CodeCompanion commands not found

```vim
:Lazy reload codecompanion
" or
:Lazy sync
```

**Problem**: Copilot authentication failed

```vim
:Copilot auth
" Follow the browser authentication flow
```

**Problem**: Chat window not appearing

```vim
:messages  " Check for errors
:checkhealth codecompanion
```

### LSP Issues

**Problem**: LSP not attaching

```vim
:LspInfo      " Check LSP status
:Mason        " Verify server installed
:checkhealth  " Check overall health
```

**Problem**: Formatter not working

```vim
:ConformInfo  " Check formatter status
```

---

## Resources

- **Neovim Documentation**: `:help <topic>` or https://neovim.io/doc/
- **Lazy.nvim**: https://github.com/folke/lazy.nvim
- **CodeCompanion**: https://github.com/olimorris/codecompanion.nvim
- **Stylua**: https://github.com/JohnnyMorganz/StyLua
- **LSP Servers**: `:help lspconfig-all`

---

_For AI Agents: Follow these guidelines strictly. Always format Lua code with stylua conventions, use pcall for safety, and test changes before committing._
