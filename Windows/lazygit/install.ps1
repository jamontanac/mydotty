[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path (Split-Path -Parent $PSScriptRoot) 'common/Installer.ps1')

Assert-PowerShell7
Assert-Winget

$packages = @(
    [pscustomobject]@{ Id = 'Git.Git'; Name = 'Git' }
    [pscustomobject]@{ Id = 'JesseDuffield.lazygit'; Name = 'Lazygit' }
    [pscustomobject]@{ Id = 'dandavison.delta'; Name = 'Delta' }
)

foreach ($package in $packages) {
    Install-WingetPackage -Id $package.Id -Name $package.Name
}

$devLinksScript = Join-Path (Split-Path -Parent $PSScriptRoot) 'dev-links/install.ps1'
& $devLinksScript -Action install

Write-Host 'Lazygit setup is complete.'