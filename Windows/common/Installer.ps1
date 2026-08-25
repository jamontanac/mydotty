 $script:MyDottyRepositoryRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

function Assert-PowerShell7 {
    if ($PSVersionTable.PSVersion.Major -lt 7) {
        throw 'PowerShell 7 or later is required. Install it with: winget install --id Microsoft.PowerShell --exact'
    }
}

function Assert-Winget {
    if ($null -eq (Get-Command -Name winget -ErrorAction SilentlyContinue)) {
        throw 'winget is required. Install or update App Installer from the Microsoft Store, then run this command again.'
    }
}

function Refresh-SessionPath {
    $pathValues = @(
        [Environment]::GetEnvironmentVariable('Path', 'Machine')
        [Environment]::GetEnvironmentVariable('Path', 'User')
        $env:Path
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    $env:Path = $pathValues -join ';'
}

function Get-RequiredCommand {
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$InstallHint
    )

    $command = Get-Command -Name $Name -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        throw "$Name is not available in this session. $InstallHint"
    }

    return $command
}

function Install-WingetPackage {
    param(
        [Parameter(Mandatory)]
        [string]$Id,

        [Parameter(Mandatory)]
        [string]$Name
    )

    Assert-Winget

    Write-Host "Ensuring $Name is installed..."
    $wingetArguments = @(
        'install'
        '--exact'
        '--id'
        $Id
        '--source'
        'winget'
        '--accept-package-agreements'
        '--accept-source-agreements'
        '--disable-interactivity'
    )

    & winget @wingetArguments
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "winget could not install $Name ($Id). Exit code: $exitCode"
    }

    Refresh-SessionPath
}

function Install-NpmGlobalPackage {
    param(
        [Parameter(Mandatory)]
        [string]$Package,

        [Parameter(Mandatory)]
        [string]$Name
    )

    $null = Get-RequiredCommand -Name 'npm' -InstallHint 'Restart the terminal after Node.js installs, then rerun this command.'

    Write-Host "Ensuring $Name is installed..."
    & npm install --global $Package
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "npm could not install $Name ($Package). Exit code: $exitCode"
    }

    Refresh-SessionPath
}

function Get-MyDottyRepositoryRoot {
    return $script:MyDottyRepositoryRoot
}

function Get-MyDottyConfigPath {
    param(
        [Parameter(Mandatory)]
        [string]$RelativePath
    )

    $configPath = Join-Path (Get-MyDottyRepositoryRoot) (Join-Path 'config' $RelativePath)
    if (-not (Test-Path -LiteralPath $configPath)) {
        throw "Expected shared configuration was not found: $configPath"
    }

    return $configPath
}