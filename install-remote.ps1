# Install clisearch from GitHub without manual clone.
# Usage:
#   irm https://raw.githubusercontent.com/Domanffe/clisearch/master/install-remote.ps1 | iex
# Or:
#   .\install-remote.ps1

param(
    [string]$Repo = 'Domanffe/clisearch',
    [string]$Branch = 'master'
)

$ErrorActionPreference = 'Stop'

$TempZip = Join-Path $env:TEMP 'clisearch-install.zip'
$TempExtract = Join-Path $env:TEMP 'clisearch-install-extract'
$BranchesToTry = @($Branch, 'master', 'main') | Select-Object -Unique

Write-Host "clisearch - remote install"
Write-Host "  repo: $Repo`n"

$downloaded = $false
foreach ($candidate in $BranchesToTry) {
    $ZipUrl = "https://github.com/$Repo/archive/refs/heads/$candidate.zip"
    Write-Host "  trying branch: $candidate"

    try {
        Invoke-WebRequest -Uri $ZipUrl -OutFile $TempZip -UseBasicParsing
        $Branch = $candidate
        $downloaded = $true
        break
    } catch {
        Write-Host "  not found: $candidate"
    }
}

if (-not $downloaded) {
    Write-Error "Could not download clisearch archive. Try: git clone https://github.com/$Repo.git"
}

Write-Host "  using branch: $Branch"

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
