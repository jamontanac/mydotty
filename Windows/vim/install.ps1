[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path (Split-Path -Parent $PSScriptRoot) 'common/Installer.ps1')

Assert-PowerShell7
Assert-Winget

$packages = @(
    [pscustomobject]@{ Id = 'vim.vim'; Name = 'Vim' }
    [pscustomobject]@{ Id = 'Git.Git'; Name = 'Git' }
    [pscustomobject]@{ Id = 'OpenJS.NodeJS.LTS'; Name = 'Node.js LTS' }
    [pscustomobject]@{ Id = 'BurntSushi.ripgrep.MSVC'; Name = 'ripgrep' }
    [pscustomobject]@{ Id = 'junegunn.fzf'; Name = 'fzf' }
)

foreach ($package in $packages) {
    Install-WingetPackage -Id $package.Id -Name $package.Name
}

$vimRoot = Join-Path $HOME '.vim'
foreach ($directory in @('autoload', 'backup', 'colors', 'plugged')) {
    New-Item -ItemType Directory -Path (Join-Path $vimRoot $directory) -Force | Out-Null
}

$vimPlugPath = Join-Path $vimRoot 'autoload/plug.vim'
if (-not (Test-Path -LiteralPath $vimPlugPath)) {
    Write-Host 'Installing vim-plug...'
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' -OutFile $vimPlugPath
} else {
    Write-Host 'vim-plug already installed.'
}

$vimCommand = Get-Command -Name 'vim.exe' -ErrorAction SilentlyContinue
if ($null -eq $vimCommand) {
    $vimCommand = Get-RequiredCommand -Name 'vim' -InstallHint 'Restart the terminal after Vim installs, then rerun this command.'
}

$vimrc = Get-MyDottyConfigPath -RelativePath 'vim/.vimrc'
Write-Host 'Installing Vim plugins...'
& $vimCommand.Source -u $vimrc -n -es '+PlugInstall --sync' '+qa'
$exitCode = $LASTEXITCODE
if ($exitCode -ne 0) {
    throw "Vim plugin installation failed. Exit code: $exitCode"
}

$copilotDirectory = Join-Path $vimRoot 'pack/github/start/copilot.vim'
if (-not (Test-Path -LiteralPath $copilotDirectory)) {
    $copilotParent = Split-Path -Parent $copilotDirectory
    New-Item -ItemType Directory -Path $copilotParent -Force | Out-Null

    $git = Get-RequiredCommand -Name 'git' -InstallHint 'Restart the terminal after Git installs, then rerun this command.'
    Write-Host 'Installing copilot.vim...'
    & $git.Source clone --depth=1 'https://github.com/github/copilot.vim.git' $copilotDirectory
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "copilot.vim installation failed. Exit code: $exitCode"
    }
} else {
    Write-Host 'copilot.vim already installed.'
}

$devLinksScript = Join-Path (Split-Path -Parent $PSScriptRoot) 'dev-links/install.ps1'
& $devLinksScript -Action install

Write-Host 'Vim setup is complete.'