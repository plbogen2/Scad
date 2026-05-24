param(
    [switch]$RenderPng = $false
)

$ScriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent -LiteralPath $MyInvocation.MyCommand.Path }
Set-Location -LiteralPath $ScriptRoot

# ---------------------------------------------------------------------------
# 1. FIND OPENSCAD
# ---------------------------------------------------------------------------
$possiblePaths = if ($IsWindows -or $env:OS -like "*Windows*") {
    @(
        "$env:LOCALAPPDATA\Programs\OpenSCAD (Nightly)",
        "C:\Program Files\OpenSCAD (Nightly)",
        "$env:LOCALAPPDATA\Programs\OpenSCAD",
        "$env:LOCALAPPDATA\OpenSCAD",
        "C:\Program Files\OpenSCAD",
        "C:\Program Files (x86)\OpenSCAD"
    )
} else {
    @("/usr/bin", "/usr/local/bin")
}

# CRITICAL: Use openscad.com on Windows so it runs synchronously
$exeName = if ($IsWindows -or $env:OS -like "*Windows*") { "openscad.com" } else { "openscad" }

$osPath = ""
foreach ($p in $possiblePaths) {
    $candidate = Join-Path $p $exeName
    if (Test-Path -LiteralPath $candidate) {
        $osPath = [System.IO.Path]::GetFullPath($candidate)
        break
    }
}

if ($osPath -eq "") {
    $cmd = Get-Command $exeName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
    if ($cmd) { $osPath = [System.IO.Path]::GetFullPath($cmd) }
}

if (!$osPath) {
    Write-Host "ERROR: OpenSCAD not found. Install it from https://openscad.org/downloads.html" -ForegroundColor Red
    exit 1
}

Write-Host "Using OpenSCAD: $osPath" -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# 2. PATHS
# ---------------------------------------------------------------------------
$scadFile = Join-Path $ScriptRoot "thing-o-matic-atx-plate.scad"
if (!(Test-Path -LiteralPath $scadFile)) {
    Write-Host "ERROR: SCAD file not found: $scadFile" -ForegroundColor Red
    exit 1
}

$stlDir  = Join-Path $ScriptRoot "STLs"
$pngDir  = Join-Path $ScriptRoot "PNGs"
$baseName = "thing-o-matic-atx-plate"
$stlFile  = Join-Path $stlDir  "$baseName.stl"
$pngFile  = Join-Path $pngDir  "$baseName.png"

if (!(Test-Path -LiteralPath $stlDir)) { New-Item -ItemType Directory -Path $stlDir -Force | Out-Null }
if ($RenderPng -and !(Test-Path -LiteralPath $pngDir)) { New-Item -ItemType Directory -Path $pngDir -Force | Out-Null }

# ---------------------------------------------------------------------------
# 3. STL EXPORT
# ---------------------------------------------------------------------------
Write-Host "Exporting STL..." -ForegroundColor Yellow
if (Test-Path $stlFile) { Remove-Item -LiteralPath $stlFile -Force }

& $osPath @("-o", $stlFile, "--enable", "all", $scadFile)

if ((Test-Path $stlFile) -and (Get-Item $stlFile).Length -gt 0) {
    Write-Host "  [STL] OK -> $stlFile" -ForegroundColor Green
} else {
    Write-Host "  [STL] FAILED" -ForegroundColor Red
    exit 1
}

# ---------------------------------------------------------------------------
# 4. PNG PREVIEW (optional, pass -RenderPng to enable)
# ---------------------------------------------------------------------------
if ($RenderPng) {
    Write-Host "Rendering PNG preview..." -ForegroundColor Yellow
    if (Test-Path $pngFile) { Remove-Item -LiteralPath $pngFile -Force }

    & $osPath @(
        "-o",           $pngFile,
        "--imgsize",    "1920,1080",
        "--colorscheme","Cornfield",
        "--viewall",
        "--autocenter",
        "--enable",     "all",
        $scadFile
    )

    if (Test-Path $pngFile) {
        Write-Host "  [PNG] OK -> $pngFile" -ForegroundColor Green
    } else {
        Write-Host "  [PNG] FAILED" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Done." -ForegroundColor Cyan
