# Windows

This setup installs Neovim, Vim, Lazygit, and the command-line tools used by their shared configuration. The editable configuration source is in the repository's `config/` directory; Windows only contains installation and linking logic.

## Prerequisites

- Windows 10 or 11 with [winget](https://learn.microsoft.com/windows/package-manager/winget/) available through App Installer.
- PowerShell 7 or later. Install it from Windows PowerShell if needed:

  ```powershell
  winget install --id Microsoft.PowerShell --exact
  ```

- Windows Developer Mode enabled, or an elevated PowerShell session. Directory links for Neovim use a junction and do not need elevation, but Vim and Lazygit use file symbolic links.

Clone this repository to a local Windows drive. Junctions do not support a remote network source path.

## Install

From the repository root, run:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\Windows\install.ps1 -Target all
```

`Bypass` applies only to this process; the script does not change your persistent execution-policy setting.

| Target | Command | Installs |
| --- | --- | --- |
| All | `-Target all` | Neovim, Vim, and Lazygit |
| Editors | `-Target editors` | Neovim and Vim |
| Terminal | `-Target terminal` | Lazygit |
| Neovim | `-Target nvim` | Neovim and its core CLI dependencies |
| Vim | `-Target vim` | Vim, vim-plug, plugins, and Copilot Vim |
| Lazygit | `-Target lazygit` | Git, Lazygit, and Delta |
| Nvim extras | `-Target nvim-extras` | Best-effort optional Neovim helpers |

For example:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\Windows\install.ps1 -Target nvim
```

If GNU Make is already installed, the equivalent convenience commands are available:

```powershell
make -C Windows all
make -C Windows nvim
make -C Windows dev-links-status
```

PowerShell is the supported bootstrap path; GNU Make is optional and is not installed by these scripts.

## Shared Configs

The link manager maps the canonical repository files to Windows application locations:

| Repository source | Active Windows location |
| --- | --- |
| `config/nvim` | `$env:LOCALAPPDATA\nvim` |
| `config/vim/.vimrc` | `$HOME\_vimrc` |
| `config/lazygit/config.yml` | `$env:LOCALAPPDATA\lazygit\config.yml` |

Run these commands from the repository root to manage links directly:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\Windows\install.ps1 -Target dev-links
pwsh -NoProfile -ExecutionPolicy Bypass -File .\Windows\install.ps1 -Target dev-links-status
pwsh -NoProfile -ExecutionPolicy Bypass -File .\Windows\install.ps1 -Target dev-links-unlink
```

When a target exists but is not this repository's expected link, it is moved to `$HOME\.mydotty-backups\<timestamp>` before linking. `unlink` removes only links managed by this setup.

## Neovim Extras

The core Neovim install includes Git, Node.js LTS, tree-sitter CLI, ripgrep, fd, and fzf. On first start, lazy.nvim and Mason install the plugins and formatters configured in `config/nvim`.

`nvim-extras` attempts to add ImageMagick and installs `pylatexenc` only when Python is already available. It reports, but does not fail for, optional tools without a dependable Windows equivalent in this setup: `onefetch`, `rsvg-convert`, and `utftex`.

Restart the terminal after installation if a newly installed executable is not found in the current session.
