[CmdletBinding()]
param(
    [ValidateSet('install', 'status', 'unlink')]
    [string]$Action = 'install'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

. (Join-Path (Split-Path -Parent $PSScriptRoot) 'common/Installer.ps1')

Assert-PowerShell7

if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
    throw 'LOCALAPPDATA is not available. Run this script from a standard Windows user profile.'
}

$script:BackupRoot = Join-Path $HOME '.mydotty-backups'
$script:BackupDirectory = Join-Path $script:BackupRoot (Get-Date -Format 'yyyyMMdd-HHmmss')
$script:BackupUsed = $false

function Get-Mappings {
    return @(
        [pscustomobject]@{
            Source = Get-MyDottyConfigPath -RelativePath 'nvim'
            Target = Join-Path $env:LOCALAPPDATA 'nvim'
            LinkType = 'Junction'
        }
        [pscustomobject]@{
            Source = Get-MyDottyConfigPath -RelativePath 'vim/.vimrc'
            Target = Join-Path $HOME '_vimrc'
            LinkType = 'SymbolicLink'
        }
        [pscustomobject]@{
            Source = Get-MyDottyConfigPath -RelativePath 'lazygit/config.yml'
            Target = Join-Path $env:LOCALAPPDATA 'lazygit/config.yml'
            LinkType = 'SymbolicLink'
        }
    )
}

function Write-ActionLog {
    param(
        [Parameter(Mandatory)]
        [string]$Message
    )

    Write-Host $Message
}

function Ensure-BackupDirectory {
    if (-not $script:BackupUsed) {
        New-Item -ItemType Directory -Path $script:BackupDirectory -Force | Out-Null
        $script:BackupUsed = $true
    }
}

function Get-BackupName {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    return ($Path -replace '[:\\/]', '__')
}

function Backup-Target {
    param(
        [Parameter(Mandatory)]
        [string]$Target
    )

    Ensure-BackupDirectory
    $backupPath = Join-Path $script:BackupDirectory (Get-BackupName -Path $Target)
    Move-Item -LiteralPath $Target -Destination $backupPath
    Write-ActionLog "Backed up $Target -> $backupPath"
}

function Test-ManagedLink {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Mapping
    )

    $item = Get-Item -LiteralPath $Mapping.Target -Force -ErrorAction SilentlyContinue
    if ($null -eq $item -or $item.LinkType -ne $Mapping.LinkType) {
        return $false
    }

    $linkTarget = @($item.Target)[0]
    if ([string]::IsNullOrWhiteSpace($linkTarget)) {
        return $false
    }

    if (-not [System.IO.Path]::IsPathRooted($linkTarget)) {
        $linkTarget = Join-Path (Split-Path -Parent $Mapping.Target) $linkTarget
    }

    try {
        $expectedPath = (Resolve-Path -LiteralPath $Mapping.Source -ErrorAction Stop).Path
        $actualPath = (Resolve-Path -LiteralPath $linkTarget -ErrorAction Stop).Path
        return $expectedPath -ieq $actualPath
    } catch {
        return $false
    }
}

function Get-LinkState {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Mapping
    )

    $item = Get-Item -LiteralPath $Mapping.Target -Force -ErrorAction SilentlyContinue
    if ($null -eq $item) {
        return 'missing'
    }

    if (Test-ManagedLink -Mapping $Mapping) {
        return 'managed'
    }

    if ($null -ne $item.LinkType) {
        return 'different-link'
    }

    return 'existing-item'
}

function New-ManagedLink {
    param(
        [Parameter(Mandatory)]
        [pscustomobject]$Mapping
    )

    $parentDirectory = Split-Path -Parent $Mapping.Target
    New-Item -ItemType Directory -Path $parentDirectory -Force | Out-Null

    try {
        New-Item -ItemType $Mapping.LinkType -Path $Mapping.Target -Target $Mapping.Source | Out-Null
    } catch {
        if ($Mapping.LinkType -eq 'SymbolicLink') {
            throw "Could not create a file symbolic link for $($Mapping.Target). Enable Windows Developer Mode or run PowerShell as Administrator, then retry. $($_.Exception.Message)"
        }

        throw
    }

    Write-ActionLog "Linked $($Mapping.Target) -> $($Mapping.Source)"
}

function Install-Mappings {
    foreach ($mapping in Get-Mappings) {
        $state = Get-LinkState -Mapping $mapping
        if ($state -eq 'managed') {
            Write-ActionLog "Already linked: $($mapping.Target) -> $($mapping.Source)"
            continue
        }

        if ($state -ne 'missing') {
            Backup-Target -Target $mapping.Target
        }

        New-ManagedLink -Mapping $mapping
    }

    if ($script:BackupUsed) {
        Write-ActionLog "Backups stored in: $script:BackupDirectory"
    } else {
        Write-ActionLog 'No backups were needed.'
    }
}

function Show-MappingStatus {
    foreach ($mapping in Get-Mappings) {
        $state = Get-LinkState -Mapping $mapping
        switch ($state) {
            'managed' { Write-ActionLog "OK   $($mapping.Target) -> $($mapping.Source)" }
            'different-link' { Write-ActionLog "DIFF $($mapping.Target) (different link)" }
            'existing-item' { Write-ActionLog "FILE $($mapping.Target) (not a managed link)" }
            default { Write-ActionLog "MISS $($mapping.Target)" }
        }
    }
}

function Remove-Mappings {
    foreach ($mapping in Get-Mappings) {
        if (Test-ManagedLink -Mapping $mapping) {
            Remove-Item -LiteralPath $mapping.Target -Force
            Write-ActionLog "Unlinked $($mapping.Target)"
        } else {
            Write-ActionLog "Skipped (not a managed link): $($mapping.Target)"
        }
    }
}

switch ($Action) {
    'install' { Install-Mappings }
    'status' { Show-MappingStatus }
    'unlink' { Remove-Mappings }
}