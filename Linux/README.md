# Linux

This setup installs Neovim, Vim, Lazygit, and the command-line tools used by their shared configuration. The editable configuration source is the repository's `config/` directory; Linux contains only installation and linking logic.

## Supported Distributions

The installers automatically detect one of these package managers:

| Distribution family | Package manager |
| --- | --- |
| Debian and Ubuntu | `apt` |
| Fedora | `dnf` |
| Arch Linux | `pacman` |

Package installation uses `sudo` when it is not run as root. To force a detected package-manager choice, prefix a command with `PACKAGE_MANAGER=apt`, `PACKAGE_MANAGER=dnf`, or `PACKAGE_MANAGER=pacman`.

## Install

From the repository root, run:

```bash
bash ./Linux/install.sh all
```

| Target | Command | Installs |
| --- | --- | --- |
| All | `all` | Neovim, Vim, and Lazygit |
| Editors | `editors` | Neovim and Vim |
| Terminal | `terminal` | Lazygit |
| Neovim | `nvim` | Neovim and core CLI dependencies |
| Vim | `vim` | Vim, vim-plug, plugins, and Copilot Vim |
| Lazygit | `lazygit` | Git, Lazygit, and Delta |
| Nvim extras | `nvim-extras` | Best-effort optional Neovim helpers |

For example:

```bash
bash ./Linux/install.sh nvim
```

GNU Make is optional. If it is already installed, equivalent commands are available:

```bash
make -C Linux all
make -C Linux nvim
make -C Linux dev-links-status
```

## Shared Configs

The link manager respects `$XDG_CONFIG_HOME`, which defaults to `~/.config`:

| Repository source | Active Linux location |
| --- | --- |
| `config/nvim` | `$XDG_CONFIG_HOME/nvim` |
| `config/vim/.vimrc` | `~/.vimrc` |
| `config/lazygit/config.yml` | `$XDG_CONFIG_HOME/lazygit/config.yml` |

Manage the links directly with:

```bash
bash ./Linux/install.sh dev-links
bash ./Linux/install.sh dev-links-status
bash ./Linux/install.sh dev-links-unlink
```

When a target exists but is not this repository's expected link, it is moved to `~/.mydotty-backups/<timestamp>` before linking. `unlink` removes only links managed by this setup.

## Neovim Dependencies

The core Neovim install includes Git, Node.js, npm, tree-sitter CLI, ripgrep, fd, fzf, and build tools for native plugin builds. It requires Neovim 0.10 or newer. If a distribution package is older, the installer downloads the current official Neovim tarball under `~/.local/opt` and exposes it through `~/.local/bin/nvim`. On Debian, Ubuntu, and Fedora, the `fd-find` package exposes `fdfind`; the installer creates a safe `~/.local/bin/fd` compatibility link when needed.

The tree-sitter CLI is installed through npm into `~/.local/bin`. Add this to your shell startup file so the directory is on your persistent `PATH` before starting Neovim:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

`nvim-extras` attempts to install ImageMagick, Python, and `pylatexenc`. It reports but does not fail for optional tools that are distribution-specific or not installed automatically: `onefetch`, `rsvg-convert`, and `utftex`.
