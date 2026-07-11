# Install clisearch from GitHub without manual clone.
# Usage:
#   irm https://raw.githubusercontent.com/Domanffe/clisearch/master/install-remote.ps1 | iex
# Or:
#   .\install-remote.ps1

param(
    [string]$Repo = 'Domanffe/clisearch',
    [string]$Branch
)

$ErrorActionPreference = 'Stop'

function Get-DefaultBranch {
    param([string]$Repository)

    $apiUrl = "https://api.github.com/repos/$Repository"
    return (Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = 'clisearch-installer' }).default_branch
}

if (-not $Branch) {
    $Branch = Get-DefaultBranch -Repository $Repo
}

$ZipUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"
$TempZip = Join-Path $env:TEMP "clisearch-$Branch.zip"
$TempExtract = Join-Path $env:TEMP "clisearch-$Branch-extract"

Write-Host "clisearch - remote install"
Write-Host "  repo: $Repo@$Branch`n"

Write-Host "  downloading..."
try {
    Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -UseBasicParsing
} catch {
    Write-Error "Failed to download $ZipUrl. Check repo/branch and try again."
}

if (Test-Path $TempExtract) {
    Remove-Item $TempExtract -Recurse -Force
}
New-Item -ItemType Directory -Path $TempExtract -Force | Out-Null
Expand-Archive -Path $TempZip -DestinationPath $TempExtract -Force

$SourceRoot = Get-ChildItem -Path $TempExtract -Directory | Select-Object -First 1
if (-not $SourceRoot) {
    Write-Error "Archive extract failed"
}

& (Join-Path $SourceRoot.FullName 'install.ps1')

Remove-Item $TempZip -Force -ErrorAction SilentlyContinue
Remove-Item $TempExtract -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "`nRemote install complete."
