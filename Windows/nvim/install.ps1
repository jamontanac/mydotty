[CmdletBinding()]
param(
    [switch]$IncludeExtras
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path (Split-Path -Parent $PSScriptRoot) 'common/Installer.ps1')

Assert-PowerShell7
Assert-Winget

$packages = @(
    [pscustomobject]@{ Id = 'Neovim.Neovim'; Name = 'Neovim' }
    [pscustomobject]@{ Id = 'Git.Git'; Name = 'Git' }
    [pscustomobject]@{ Id = 'OpenJS.NodeJS.LTS'; Name = 'Node.js LTS' }
    [pscustomobject]@{ Id = 'BurntSushi.ripgrep.MSVC'; Name = 'ripgrep' }
    [pscustomobject]@{ Id = 'sharkdp.fd'; Name = 'fd' }
    [pscustomobject]@{ Id = 'junegunn.fzf'; Name = 'fzf' }
)

foreach ($package in $packages) {
    Install-WingetPackage -Id $package.Id -Name $package.Name
}

Install-NpmGlobalPackage -Package 'tree-sitter-cli' -Name 'tree-sitter CLI'

$devLinksScript = Join-Path (Split-Path -Parent $PSScriptRoot) 'dev-links/install.ps1'
& $devLinksScript -Action install

if ($IncludeExtras) {
    try {
        Install-WingetPackage -Id 'ImageMagick.ImageMagick' -Name 'ImageMagick'
    } catch {
        Write-Warning "ImageMagick was not installed. Presentation image conversion remains optional. $($_.Exception.Message)"
    }

    $python = Get-Command -Name python -ErrorAction SilentlyContinue
    if ($null -eq $python) {
        Write-Warning 'Skipping pylatexenc because Python is not installed. Install Python and run: python -m pip install --user --upgrade pylatexenc'
    } else {
        & $python.Source -m pip install --user --upgrade pylatexenc
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "pylatexenc was not installed. LaTeX text conversion remains optional. Exit code: $LASTEXITCODE"
        }
    }

    Write-Warning 'onefetch, rsvg-convert, and utftex are optional and are not installed automatically on Windows.'
}

Write-Host 'Neovim setup is complete. Start Neovim once to let lazy.nvim and Mason install configured plugins and tools.'