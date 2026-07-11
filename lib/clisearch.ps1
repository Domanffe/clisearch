param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$CliArgs
)

$ErrorActionPreference = 'Stop'

$InstallRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$BangsPath = Join-Path $InstallRoot 'config\bangs.json'

function Get-Bangs {
    if (-not (Test-Path $BangsPath)) {
        Write-Error "Config not found: $BangsPath"
    }
    return Get-Content -Raw -Path $BangsPath | ConvertFrom-Json
}

function Show-Help {
    @(
        'clisearch - bang search from the command line',
        '',
        'Usage:',
        '  cs <bang> <query>     Search (example: cs yt lofi music)',
        '  cs !<bang> <query>    Same with ! prefix (example: cs !gh rust)',
        '  cs list               List available bangs',
        '  <bang> <query>        Shortcut (example: yt lofi music)',
        '',
        'Flags:',
        '  -h, --help            Show help',
        '  --list                List bangs',
        '  --dry-run             Print URL without opening browser'
    ) | ForEach-Object { Write-Host $_ }
}

function Show-BangList {
    $bangs = Get-Bangs
    Write-Host 'Available bangs:'
    Write-Host ''
    foreach ($prop in $bangs.PSObject.Properties | Sort-Object Name) {
        Write-Host ("  {0,-4}  {1}" -f $prop.Name, $prop.Value.name)
    }
    Write-Host ''
    Write-Host 'Usage: cs <bang> <query>  or  <bang> <query>'
}

function Get-SearchUrl {
    param(
        [string]$Bang,
        [string]$Query
    )

    $entry = Get-Bangs | Select-Object -ExpandProperty $Bang -ErrorAction SilentlyContinue
    if (-not $entry) {
        Write-Error "Unknown bang: $Bang. Run 'cs list' to see available commands."
    }

    if ([string]::IsNullOrWhiteSpace($Query)) {
        return $entry.home
    }

    return $entry.url.Replace('{q}', [uri]::EscapeDataString($Query))
}

$remaining = @($CliArgs)

if ($remaining -contains '--dry-run') {
    $dryRun = $true
    $remaining = @($remaining | Where-Object { $_ -ne '--dry-run' })
} else {
    $dryRun = $false
}

if ($remaining.Count -eq 0 -or $remaining[0] -in '-h', '--help') {
    Show-Help
    exit 0
}

if ($remaining[0] -in '--list', 'list') {
    Show-BangList
    exit 0
}

$bang = [string]$remaining[0]
if ($bang.StartsWith('!')) {
    $bang = $bang.Substring(1)
}

$query = if ($remaining.Count -gt 1) {
    ($remaining[1..($remaining.Count - 1)] -join ' ').Trim()
} else {
    ''
}

$url = Get-SearchUrl -Bang $bang -Query $query

if ($dryRun) {
    Write-Output $url
    exit 0
}

Start-Process $url
