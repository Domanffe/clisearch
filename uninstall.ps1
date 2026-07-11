$ErrorActionPreference = 'Stop'

$TargetRoot = Join-Path $env:LOCALAPPDATA 'clisearch'
$PathEntry = Join-Path $TargetRoot 'bin'

Write-Host "clisearch - uninstall`n"

$userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($userPath) {
    $pathParts = $userPath -split ';' | Where-Object {
        $_ -and $_.Trim() -ne '' -and $_.Trim() -ne $PathEntry
    }
    $newPath = ($pathParts -join ';').TrimEnd(';')
    [Environment]::SetEnvironmentVariable('Path', $newPath, 'User')
    Write-Host "  removed from PATH: $PathEntry"
}

if (Test-Path $TargetRoot) {
    Remove-Item -Path $TargetRoot -Recurse -Force
    Write-Host "  deleted: $TargetRoot"
} else {
    Write-Host "  not installed: $TargetRoot"
}

Write-Host "`nDone. Restart your terminal."
