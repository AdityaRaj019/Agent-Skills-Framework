[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [ValidateSet('Link', 'Copy')]
    [string]$Mode = 'Link',

    [switch]$Force,

    [switch]$NoBridge
)

$ErrorActionPreference = 'Stop'

function Resolve-FullPath {
    param([Parameter(Mandatory = $true)][string]$Path)

    if (Test-Path -LiteralPath $Path) {
        return (Resolve-Path -LiteralPath $Path).Path
    }

    $parent = Split-Path -Parent $Path
    $leaf = Split-Path -Leaf $Path
    if (-not $parent) {
        $parent = '.'
    }

    $resolvedParent = (Resolve-Path -LiteralPath $parent).Path
    return (Join-Path $resolvedParent $leaf)
}

$scriptDir = Split-Path -Parent $PSCommandPath
$frameworkRoot = Resolve-FullPath (Join-Path $scriptDir '..')
$sourceAgents = Join-Path $frameworkRoot '.agents'

if (-not (Test-Path -LiteralPath $sourceAgents -PathType Container)) {
    throw "Framework source not found: $sourceAgents"
}

$targetProject = Resolve-FullPath $ProjectPath
if (-not (Test-Path -LiteralPath $targetProject -PathType Container)) {
    throw "Project path does not exist: $targetProject"
}

$targetAgents = Join-Path $targetProject '.agents'
$bridgeFile = Join-Path $targetProject 'AGENTS.md'

if (Test-Path -LiteralPath $targetAgents) {
    $existing = Get-Item -LiteralPath $targetAgents -Force
    $sameTarget = $false

    if ($existing.LinkType -eq 'Junction' -or $existing.LinkType -eq 'SymbolicLink') {
        $sameTarget = ((Resolve-FullPath $existing.Target) -eq (Resolve-FullPath $sourceAgents))
    }

    if ($sameTarget) {
        Write-Host ".agents is already linked to this framework."
    } elseif ($Force) {
        $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
        $backupPath = Join-Path $targetProject ".agents.backup-$stamp"
        Move-Item -LiteralPath $targetAgents -Destination $backupPath
        Write-Host "Existing .agents moved to $backupPath"
    } else {
        throw "Target already has .agents. Re-run with -Force to back it up and install this framework."
    }
}

if (-not (Test-Path -LiteralPath $targetAgents)) {
    if ($Mode -eq 'Link') {
        New-Item -ItemType Junction -Path $targetAgents -Target $sourceAgents | Out-Null
        Write-Host "Linked .agents -> $sourceAgents"
    } else {
        Copy-Item -LiteralPath $sourceAgents -Destination $targetAgents -Recurse
        Write-Host "Copied .agents from $sourceAgents"
    }
}

if (-not $NoBridge) {
    $bridgeContent = @'
# Agent Instructions

This project uses the shared `.agents` framework.

Before making project decisions or code changes, read:

1. `.agents/README.md`
2. `.agents/AGENT.md`
3. `.agents/CONTEXT.md`

Use `.agents/CONTEXT.md` to recover project memory from Graphify output and Obsidian files such as `Action_Register.md` and `Context_state.md`.

'@

    if (Test-Path -LiteralPath $bridgeFile) {
        $existingBridge = Get-Content -Raw -LiteralPath $bridgeFile
        if ($existingBridge -notmatch [regex]::Escape('This project uses the shared `.agents` framework.')) {
            Add-Content -LiteralPath $bridgeFile -Value "`n$bridgeContent"
            Write-Host "Appended .agents bridge instructions to AGENTS.md"
        } else {
            Write-Host "AGENTS.md already contains .agents bridge instructions."
        }
    } else {
        Set-Content -LiteralPath $bridgeFile -Value $bridgeContent -Encoding UTF8
        Write-Host "Created AGENTS.md bridge file."
    }
}

Write-Host "Done. Project is using the AI framework."

