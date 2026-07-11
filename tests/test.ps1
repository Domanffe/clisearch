$ErrorActionPreference = 'Stop'

$Core = Join-Path $PSScriptRoot '..\lib\clisearch.ps1'

function Assert-Equal {
    param(
        [string]$Name,
        [string]$Actual,
        [string]$Expected
    )

    if ($Actual -ne $Expected) {
        throw "$Name`: expected '$Expected', got '$Actual'"
    }
}

function Assert-Match {
    param(
        [string]$Name,
        [string]$Actual,
        [string]$Pattern
    )

    if ($Actual -notmatch $Pattern) {
        throw "$Name`: '$Actual' does not match '$Pattern'"
    }
}

Assert-Equal 'yt search' (& $Core yt 'lofi hip hop' --dry-run) 'https://www.youtube.com/results?search_query=lofi%20hip%20hop'
Assert-Equal 'bang prefix' (& $Core '!gh' 'rust async' --dry-run) 'https://github.com/search?q=rust%20async'
Assert-Equal 'home page' (& $Core yt --dry-run) 'https://www.youtube.com/'
Assert-Match 'wikipedia' (& $Core w Linux --dry-run) 'wikipedia\.org'

Write-Host 'All tests passed.'
