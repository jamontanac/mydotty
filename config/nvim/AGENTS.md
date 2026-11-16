# AGENTS.md — Neovim configuration

Guide for AI agents (and humans) editing this config. Keep it in sync with the code.

## Overview

- Neovim **0.12+** (nvim-treesitter `main` and `vim.diagnostic` `jump.on_jump` need it),
  plugin manager **lazy.nvim**, config written in Lua.
- Source lives in `config/nvim` of the `mydotty` repo and is linked by the per-OS
  `dev-links` scripts (symlink on macOS/Linux, junction on Windows) to: macOS
  `~/.config/nvim`, Linux `$XDG_CONFIG_HOME/nvim` (default `~/.config/nvim`), Windows
  `%LOCALAPPDATA%\nvim`. The same files run on all three — keep changes portable.
- Leader key: `<Space>` (also local leader).

## Layout

```
init.lua                  -- loads core/*, bootstraps lazy.nvim, lists active plugins
stylua.toml               -- Lua formatting rules
lazy-lock.json            -- plugin lockfile (written by lazy.nvim, never edit by hand)
lua/core/options.lua      -- options (only non-default ones), backup/undo dir
lua/core/keymaps.lua      -- global keymaps
lua/core/snippets.lua     -- user commands, autocmds, filetype tweaks, ~/.env loader
lua/plugins/*.lua         -- one lazy.nvim spec (or list of specs) per file
lua/plugins/floating-terminal/  -- own plugin: floating terminals (required directly from init.lua)
lua/plugins/present/      -- own plugin: markdown presentations (loaded on demand by :StartPresentation)
lua/files/                -- dashboard art / footer for alpha
templates/                -- obsidian.nvim note templates
plugins/presentations/    -- sample decks for the present plugin
```

### Active vs inactive plugins

A plugin file is active only if `init.lua` requires it. These files are **inactive on
purpose and must be kept** (the owner toggles them by commenting the `require`):
`avante`, `codecompanion`, `diagrams`, `markdown_preview`, `nabla`, `new_bufferline`,
`registers_management`, `todo-comments` (todo-comments is configured in `misc.lua`) and
`opencode-terminal` (fully commented out). `present` is not required from `init.lua` but
`:StartPresentation` (in `snippets.lua`) loads it on demand.
Commented-out alternative plugin specs inside active files (none-ls, markview,
dashboard-nvim, image.nvim, easy-align, …) are kept for the same reason.

## Conventions

- **Formatting**: from `config/nvim` run `~/.local/share/nvim/mason/bin/stylua init.lua lua/`
  (stylua comes from Mason and is not on the shell `PATH`). `stylua.toml`: 4-space indent,
  single quotes preferred, no parentheses for single string/table arguments.
- **Specs**: prefer `opts = {}` (lazy.nvim then calls `setup(opts)`); use `config` only
  when extra code is needed. Use lazy triggers (`event`, `cmd`, `keys`, `ft`) where safe.
- **Keymaps**: `vim.keymap.set(mode, lhs, rhs, { desc = '...' })` — options go in the
  **4th** argument (a 5th argument is silently ignored). Every map gets a `desc`.
  Do not create `<leader>` maps in terminal mode (every typed space would wait for
  `timeoutlen`); use an `<M-…>` key there.
- **Autocmds**: give new autocmds a named augroup with `{ clear = true }`. Exception: a
  group that collects buffer-local autocmds across buffers (`kickstart-lsp-highlight` in
  `lsp.lua`) must keep `{ clear = false }`.
- **Built-ins first**: Neovim already provides `[d`/`]d`, visual `*`/`#`, `gr*` LSP maps,
  comment toggling (`gc`), etc. Don't re-implement them, and don't set options to their
  default values. (`lsp.lua` intentionally overrides `grr`/`gri`/`grd`/`grt`/`gO`/`gW` with
  Telescope pickers and re-binds `grn`/`gra` only to add a `desc` — keep those.)
- **Lua patterns**: in `file_ignore_patterns` and similar, escape dots (`%.git`) and match
  both separators (`[/\\]`) — Windows paths use `\`.
- **Commits**: no AI co-author trailers.

## LSP, tools and formatting

- **LSP** (`lua/plugins/lsp.lua`): servers are declared in the `servers` table and
  registered with `vim.lsp.config`; mason-lspconfig v2 enables installed ones
  automatically. Current servers: `clangd`, `rust_analyzer`, `ruff`, `pyrefly`,
  `lua_ls`, `julials`, `jsonls`, `yamlls`, `sqlls`, `terraformls`, `bashls`,
  `dockerls`, `docker_compose_language_service`. mason-lspconfig also auto-enables any
  other installed Mason package that has an lspconfig config — today `stylua` (installed
  as a formatter) also runs as `stylua --lsp` in Lua buffers.
  `lsp_nvim.lua` adds lazydev for Neovim Lua APIs.
- **Installing tools**: add a server to the `servers` table in `lsp.lua` (it is copied into
  mason-tool-installer's `ensure_installed` and gets the blink capabilities); add formatters
  and other Mason tools to the `vim.list_extend(ensure_installed, {...})` list in the same
  file. Never call mason-tool-installer's `setup()` elsewhere: it installs on `VimEnter`, so
  a `setup()` in a lazily loaded plugin would never install anything.
- **Diagnostics**: `[d`/`]d` jump and open a float (`jump.on_jump`), `<leader>d` float,
  `<leader>q` location list.
- **Formatting** (`lua/plugins/autoformatter.lua`, conform.nvim): format on save
  (`<leader>wf` saves without formatting, `<leader>f` formats manually).

  | Filetype | Formatter |
  | --- | --- |
  | lua | stylua |
  | python | ruff_organize_imports + ruff_format (`:RuffAutofix`, `:RuffOrganizeImports` for code actions) |
  | c, cpp, cuda | clang-format |
  | sh, bash | shfmt (2-space) |
  | javascript, html, css, markdown | prettier |
  | yaml | prettier (4-space) |
  | json | jq (4-space) |
  | terraform, tf, hcl | terraform_fmt (needs the `terraform` CLI, not installed by Mason; otherwise falls back to the LSP) |
  | rust | rustfmt (from rustup, not Mason) |
  | julia | no conform entry: julials (LanguageServer.jl, uses JuliaFormatter) formats via the LSP fallback |

  Any filetype without an available formatter falls back to LSP formatting (`lsp_format = 'fallback'`).

- **CUDA**: `.cu`/`.cuh` → `cuda` filetype, treesitter `cuda` parser, clangd, clang-format.
  On macOS there is no CUDA toolkit, so clangd diagnostics are hidden in cuda buffers
  (navigation still works); code is built on Linux, where nothing is hidden.
- **Completion**: blink.cmp (`default` preset: `<C-y>` accept, `<C-n>`/`<C-p>` select,
  `<C-space>` docs, `<C-e>` hide, `<C-k>` signature) with LSP, path, LuaSnip snippets,
  lazydev and Copilot (copilot.lua, suggestions shown only through blink).

## Keymaps

**Core**: `jk`/`jj` leave insert · `<Esc>` clear search highlight · `<C-h/j/k/l>` move
between windows · arrows resize · `<C-u>`/`<C-d>`/`n`/`N` keep the cursor centred ·
`<A-j>`/`<A-k>` move line/selection · `<C-q>` quit · `<leader>c` close window ·
`<leader>x` close buffer but keep the window (terminals/special buffers/floats use `:bd`,
which asks before killing a job) · `<leader>tlw` toggle wrap · `<leader>u` undotree.

**Search (Telescope)**: `<leader>sf` files · `<leader>sg` grep whole project ·
`<leader>s/` grep open files · `<leader>sw` word under cursor · `<leader>s.` recent ·
`<leader><leader>` buffers · `<leader>sh` help · `<leader>sk` keymaps · `<leader>sd`
diagnostics · `<leader>sm` marks · `<leader>sn` Neovim config files · `<leader>ss`
pickers · `<leader>slsp` document symbols. In a picker `<C-q>` sends results to quickfix.

**LSP (buffer-local)**: `grn` rename · `gra` code action · `grr` references · `gri`
implementation · `grd` definition · `grD` declaration · `grt` type definition · `gO`
document symbols (only when the server provides symbols, so markdown keeps Neovim's
heading outline) · `gW` workspace symbols · `<leader>th` toggle inlay hints.

**Code navigation (treesitter)**: `]f`/`[f` next/prev function start, `]F`/`[F` end ·
`]k`/`[k` class start, `]K`/`[K` end · text objects `af`/`if`, `ac`/`ic`, `aa`/`ia` ·
`<leader>sp`/`<leader>sP` swap parameter. `]c`/`[c` are left to Neovim (next/prev change
in diff mode).

**Buffers (bufferline)**: `<leader>b1`…`<leader>b0` go to buffer · `<A-,>` next,
`<A-S-,>` previous · `<leader>pb` pick · `<leader>bL`/`<leader>bR` move ·
`<leader>mb1`/`<leader>mb0` move to first/last · `<leader>tg1..3` toggle groups.

**Files (oil)**: `-` parent directory · `<leader>-` oil float. Inside oil
(`use_default_keymaps = false`): `<CR>` open · `<C-v>`/`<C-h>`/`<C-t>` open in
vsplit/split/tab · `<C-p>` preview · `<C-l>` refresh · `-` parent · `_` cwd · `g.` hidden
files · `gs` sort · `gx` open externally · `<F2>` help · `<leader>x` close oil. Note
`<C-h>`/`<C-l>` do not move between windows inside oil.

**Terminal**: `<M-t>` toggle floating terminal (normal + terminal mode) · `<leader>tt`
same from normal mode · `<leader>t1`/`<leader>t2` specific terminal · `<leader>tc` cycle ·
`<Esc><Esc>` leave terminal mode.

**macOS Option key**: Ghostty has `macos-option-as-alt` off on purpose (Latin American
layout needs Option for `@`, `\`, …), so an Option combo reaches Neovim as Alt only when it
does not type a character. Option+t types `†`, so `<M-t>` does not fire on the Mac — use
`<leader>tt`. Option+j/k type nothing, so `<A-j>`/`<A-k>` work. Check any new `<A-…>` map
on this layout.

**Git**: `<leader>lg` LazyGit · gitsigns signs · vim-fugitive commands.

**AI (opencode.nvim, `<leader>a`)**: `at` ask about this · `as` select prompt · `a.` send
this · `ab` send buffer · `aab` send all buffers · `a<Tab>` cycle agent · `ac` choose
session · `an` new session. `a.`/`ab`/`aab` call `prompt '@…'` without a trailing space,
which submits immediately (a trailing space, e.g. `prompt '@this '`, would only append).

**Editing**: mini.surround `sa`/`sd`/`sr`/`sf`/`sF`/`sh` · mini.align `ga`/`gA`.

**Obsidian (markdown buffers)**: `gf` follow link · `<leader>ch` toggle checkbox ·
`<leader>onn` new note (note template) · `<leader>ont` new from template · `<leader>onN`
new note · `<leader>ond` today's daily note · `<leader>oc` quick switch · `<leader>ob`
backlinks · visual `<leader>ol`/`<leader>oL` link selection to an existing/new note.
Vault: `$OBSIDIAN_VAULT` or `~/vaults/personal`.

## Testing a change

```sh
cd config/nvim && ~/.local/share/nvim/mason/bin/stylua --check init.lua lua/   # formatting
# startup errors, including plugins loaded on VimEnter (a plain "+cmd" runs before VimEnter)
nvim --headless "+lua vim.schedule(function() print(vim.fn.execute('messages')) vim.cmd('qa!') end)"
```

Inside Neovim: `:messages`, `:checkhealth`, `:checkhealth vim.lsp`, `:Lazy`,
`:Mason`, `:ConformInfo`. When scripting headless checks, always add a kill timeout
around `nvim --headless` (a Lua error before `qa!` leaves it running).

## Notes

- `have_nerd_font = true` (Ghostty uses 0x Proto Nerd Font); icons come from
  nvim-web-devicons and `nvim-mini/mini.icons`.
- Backups and undo files go to `config/nvim/backup/` (gitignored).
- `~/.env` is loaded into `vim.env` at startup (`snippets.lua`).
- opencode.nvim reads `vim.g.opencode_opts`; its option names changed upstream, so check
  `lua/opencode/config.lua` of the installed plugin before adding any.
