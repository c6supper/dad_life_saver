<#
.SYNOPSIS
    Render an HTML document to a print-ready PDF (and optionally a PNG preview).

.DESCRIPTION
    mistake-book skill helper.

    Windows-only, and requires nothing to be installed: it drives the Chromium
    engine already present in Microsoft Edge or Google Chrome.

    Two deliberate design choices, both learned the hard way:

      * Parameters are named -Html / -Pdf. Names like -Input / -Output collide
        with PowerShell's automatic $Input / $Output variables, which shadow the
        bound parameter and silently bind an empty string.

      * The render happens in an ASCII-only temp directory and the result is
        then moved into place. Non-ASCII characters (e.g. Chinese folder names
        such as 七上) can be mangled when passed to a native executable's command
        line, so the browser never sees them.

    Windows ships with the PowerShell execution policy set to Restricted, which
    blocks .ps1 files outright. Invoke this through a child PowerShell:

        powershell -NoProfile -ExecutionPolicy Bypass -File render.ps1 -Html a.html -Pdf a.pdf

.EXAMPLE
    powershell -NoProfile -ExecutionPolicy Bypass -File .\render.ps1 `
        -Html .\错题练习卷.html -Pdf .\错题练习卷.pdf -Png
#>
[CmdletBinding()]
param(
    # Input HTML document.
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Html,

    # Destination PDF. A .pdf extension is enforced.
    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Pdf,

    # Also write a <Pdf>.png preview next to the PDF.
    [switch]$Png,

    # Pixel width used for the PNG preview only.
    [int]$PngWidth = 900,

    # Give up if the browser has not produced a file within this many seconds.
    [int]$TimeoutSeconds = 90,

    # Explicit browser executable. Auto-detected when omitted.
    [string]$Browser
)

$ErrorActionPreference = 'Stop'

function Find-Browser {
    param([string]$Explicit)

    if ($Explicit) {
        if (Test-Path -LiteralPath $Explicit) { return (Resolve-Path -LiteralPath $Explicit).Path }
        throw "Browser not found at: $Explicit"
    }

    $candidates = @(
        "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
        "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
        "$env:ProgramFiles\Google\Chrome\Application\chrome.exe"
        "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe"
        "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe"
    )

    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate)) { return $candidate }
    }

    throw "No Chromium browser found (looked for Microsoft Edge and Google Chrome). Install one, or pass -Browser 'C:\path\to\msedge.exe'."
}

function Invoke-BrowserRender {
    param(
        [string]$BrowserPath,
        [string[]]$ExtraArgs,
        [string]$Target,
        [int]$Timeout
    )

    $profile = Join-Path $script:WorkDir 'profile'
    $stderr  = Join-Path $script:WorkDir 'stderr.txt'
    $stdout  = Join-Path $script:WorkDir 'stdout.txt'

    $args = @(
        '--headless=new'
        '--disable-gpu'
        '--no-first-run'
        '--no-default-browser-check'
        '--disable-extensions'
        '--disable-background-networking'
        '--hide-scrollbars'
        "--user-data-dir=`"$profile`""
        '--virtual-time-budget=10000'
    ) + $ExtraArgs

    if (Test-Path -LiteralPath $Target) { Remove-Item -LiteralPath $Target -Force }

    $proc = Start-Process -FilePath $BrowserPath `
        -ArgumentList ($args -join ' ') `
        -NoNewWindow -PassThru `
        -RedirectStandardOutput $stdout `
        -RedirectStandardError $stderr

    if (-not $proc.WaitForExit($Timeout * 1000)) {
        try { $proc.Kill() } catch { }
        throw "Browser timed out after $Timeout seconds while rendering '$Target'."
    }

    if (-not (Test-Path -LiteralPath $Target)) {
        $detail = ''
        if (Test-Path -LiteralPath $stderr) {
            $detail = Get-Content -LiteralPath $stderr -Raw -ErrorAction SilentlyContinue
        }
        throw "Browser produced no output for '$Target'.$([Environment]::NewLine)$detail"
    }
}

# --- resolve input ----------------------------------------------------------

$htmlPath = (Resolve-Path -LiteralPath $Html).Path
if (-not (Test-Path -LiteralPath $htmlPath -PathType Leaf)) {
    throw "Input is not a file: $htmlPath"
}
if ([System.IO.Path]::GetExtension($htmlPath).ToLowerInvariant() -notin @('.html', '.htm')) {
    Write-Warning "Input '$htmlPath' is not .html/.htm; Chromium will still attempt to render it."
}

# --- resolve output ---------------------------------------------------------

if ([System.IO.Path]::GetExtension($Pdf).ToLowerInvariant() -ne '.pdf') {
    $Pdf = [System.IO.Path]::ChangeExtension($Pdf, '.pdf')
}
$pdfPath = [System.IO.Path]::GetFullPath($Pdf)
$pdfDir  = [System.IO.Path]::GetDirectoryName($pdfPath)
if ($pdfDir -and -not (Test-Path -LiteralPath $pdfDir)) {
    New-Item -ItemType Directory -Path $pdfDir -Force | Out-Null
}

$pngPath = $null
if ($Png) {
    $pngPath = [System.IO.Path]::ChangeExtension($pdfPath, '.png')
}

$browserPath = Find-Browser -Explicit $Browser

# --- work area (ASCII only) -------------------------------------------------

$script:WorkDir = Join-Path ([System.IO.Path]::GetTempPath()) ("mb-render-" + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $script:WorkDir -Force | Out-Null

$tmpPdf = Join-Path $script:WorkDir 'out.pdf'
$tmpPng = Join-Path $script:WorkDir 'out.png'

# Chromium resolves the document's relative links (e.g. ../assets/print.css)
# against the real file location, so we render from the original path.
$uri = ([System.Uri]$htmlPath).AbsoluteUri

try {
    Invoke-BrowserRender -BrowserPath $browserPath `
        -ExtraArgs @("--print-to-pdf=`"$tmpPdf`"", "`"$uri`"") `
        -Target $tmpPdf -Timeout $TimeoutSeconds

    # Validate before publishing, so a broken render never overwrites a good file.
    $bytes = [System.IO.File]::ReadAllBytes($tmpPdf)
    if ($bytes.Length -lt 1000) {
        throw "Rendered PDF is suspiciously small ($($bytes.Length) bytes)."
    }
    $magic = [System.Text.Encoding]::ASCII.GetString($bytes, 0, 4)
    if ($magic -ne '%PDF') {
        throw "Rendered file is not a PDF (header '$magic')."
    }

    if (Test-Path -LiteralPath $pdfPath) { Remove-Item -LiteralPath $pdfPath -Force }
    Move-Item -LiteralPath $tmpPdf -Destination $pdfPath -Force

    if ($pngPath) {
        Invoke-BrowserRender -BrowserPath $browserPath `
            -ExtraArgs @("--window-size=$PngWidth,1160", "--screenshot=`"$tmpPng`"", "`"$uri`"") `
            -Target $tmpPng -Timeout $TimeoutSeconds

        if (Test-Path -LiteralPath $pngPath) { Remove-Item -LiteralPath $pngPath -Force }
        Move-Item -LiteralPath $tmpPng -Destination $pngPath -Force
    }

    Write-Host ("PDF : {0} ({1:N0} bytes)" -f $pdfPath, $bytes.Length)
    if ($pngPath) {
        Write-Host ("PNG : {0} ({1:N0} bytes)" -f $pngPath, (Get-Item -LiteralPath $pngPath).Length)
    }
}
finally {
    if (Test-Path -LiteralPath $script:WorkDir) {
        Remove-Item -LiteralPath $script:WorkDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}
