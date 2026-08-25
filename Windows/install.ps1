[CmdletBinding()]
param(
    [ValidateSet('all', 'editors', 'terminal', 'nvim', 'vim', 'lazygit', 'nvim-extras', 'dev-links', 'dev-links-status', 'dev-links-unlink')]
    [string]$Target = 'all'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot 'common/Installer.ps1')

Assert-PowerShell7

function Invoke-Installer {
    param(
        [Parameter(Mandatory)]
        [string]$RelativePath,

        [string[]]$Arguments = @()
    )

    $scriptPath = Join-Path $PSScriptRoot $RelativePath
    & $scriptPath @Arguments
}

if ($Target -notin @('dev-links', 'dev-links-status', 'dev-links-unlink')) {
    Assert-Winget
}

switch ($Target) {
    'all' {
        Invoke-Installer -RelativePath 'nvim/install.ps1'
        Invoke-Installer -RelativePath 'vim/install.ps1'
        Invoke-Installer -RelativePath 'lazygit/install.ps1'
    }
    'editors' {
        Invoke-Installer -RelativePath 'nvim/install.ps1'
        Invoke-Installer -RelativePath 'vim/install.ps1'
    }
    'terminal' {
        Invoke-Installer -RelativePath 'lazygit/install.ps1'
    }
    'nvim' {
        Invoke-Installer -RelativePath 'nvim/install.ps1'
    }
    'vim' {
        Invoke-Installer -RelativePath 'vim/install.ps1'
    }
    'lazygit' {
        Invoke-Installer -RelativePath 'lazygit/install.ps1'
    }
    'nvim-extras' {
        Invoke-Installer -RelativePath 'nvim/install.ps1' -Arguments @('-IncludeExtras')
    }
    'dev-links' {
        Invoke-Installer -RelativePath 'dev-links/install.ps1' -Arguments @('-Action', 'install')
    }
    'dev-links-status' {
        Invoke-Installer -RelativePath 'dev-links/install.ps1' -Arguments @('-Action', 'status')
    }
    'dev-links-unlink' {
        Invoke-Installer -RelativePath 'dev-links/install.ps1' -Arguments @('-Action', 'unlink')
    }
}

Write-Host "Completed Windows target: $Target"