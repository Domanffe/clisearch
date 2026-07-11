$ErrorActionPreference = 'Stop'

$SourceRoot = $PSScriptRoot
$TargetRoot = Join-Path $env:LOCALAPPDATA 'clisearch'
$PathEntry = Join-Path $TargetRoot 'bin'

Write-Host "clisearch - install`n"

foreach ($dir in 'bin', 'lib', 'config') {
    $src = Join-Path $SourceRoot $dir
    $dst = Join-Path $TargetRoot $dir

    if (-not (Test-Path $src)) {
        Write-Error "Missing source directory: $src"
    }

    if (Test-Path $dst) {
        Remove-Item -Path $dst -Recurse -Force
    }

    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    Copy-Item -Path (Join-Path $src '*') -Destination $dst -Recurse -Force
    Write-Host "  copied $dir/"
}

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
$pathParts = if ($userPath) {
    $userPath -split ';' | Where-Object { $_ -and $_.Trim() }
} else {
    @()
}

if ($pathParts -notcontains $PathEntry) {
    $pathParts += $PathEntry
    [Environment]::SetEnvironmentVariable('Path', ($pathParts -join ';').TrimEnd(';'), 'User')
    Write-Host "  added to PATH: $PathEntry"
} else {
    Write-Host "  PATH already contains: $PathEntry"
}

$env:Path = "$PathEntry;$env:Path"

Write-Host "`nVerifying install..."
$ytCmd = Get-Command yt -ErrorAction SilentlyContinue
if ($ytCmd) {
    Write-Host "  yt -> $($ytCmd.Source)"
} else {
    Write-Warning "  yt not found in current session PATH (restart terminal after install)"
}

$core = Join-Path $TargetRoot 'lib\clisearch.ps1'
Write-Host "  dry-run: $(& $core yt test --dry-run)"

Write-Host @"

Done! Installed to: $TargetRoot

Examples:
  yt lofi hip hop
  cs !gh neovim config
  cs list

Restart your terminal (or Win+R) so PATH updates everywhere.
"@
