param(
    [switch]$RenderPng = $false,
    # Optionally limit to specific cutter names, e.g. -Cutters coffin,tamale
    [string[]]$Cutters = @()
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
# 2. DISCOVER CUTTERS
# ---------------------------------------------------------------------------
$cuttersRoot = Join-Path $ScriptRoot "cutters"
$allScadFiles = Get-ChildItem -Path $cuttersRoot -Recurse -Filter "*.scad" | Sort-Object FullName

if ($Cutters.Count -gt 0) {
    $allScadFiles = $allScadFiles | Where-Object { $Cutters -contains $_.Directory.Name }
}

if ($allScadFiles.Count -eq 0) {
    Write-Host "ERROR: No SCAD files found under $cuttersRoot" -ForegroundColor Red
    exit 1
}

Write-Host "Cutters to build: $($allScadFiles.Directory.Name -join ', ')" -ForegroundColor Yellow

# ---------------------------------------------------------------------------
# 3. OUTPUT DIRECTORIES
# ---------------------------------------------------------------------------
$stlDir = Join-Path $ScriptRoot "STLs"
$pngDir = Join-Path $ScriptRoot "PNGs"
if (!(Test-Path -LiteralPath $stlDir)) { New-Item -ItemType Directory -Path $stlDir -Force | Out-Null }
if ($RenderPng -and !(Test-Path -LiteralPath $pngDir)) { New-Item -ItemType Directory -Path $pngDir -Force | Out-Null }

# ---------------------------------------------------------------------------
# 4. RENDER LOOP
# ---------------------------------------------------------------------------
Write-Host "--- Starting Render Loop ---" -ForegroundColor Cyan
$anyFailed = $false

foreach ($scadFile in $allScadFiles) {
    $baseName = $scadFile.Directory.Name   # e.g. "coffin", "tamale"
    $stlFile  = Join-Path $stlDir "$baseName.stl"
    $pngFile  = Join-Path $pngDir "$baseName.png"

    Write-Host "Rendering: $baseName" -ForegroundColor Yellow

    # --- STL ---
    if (Test-Path $stlFile) { Remove-Item -LiteralPath $stlFile -Force }
    & $osPath @("-o", $stlFile, "--enable", "all", $scadFile.FullName)

    if ((Test-Path $stlFile) -and (Get-Item $stlFile).Length -gt 0) {
        Write-Host "  [STL] OK -> $stlFile" -ForegroundColor Green
    } else {
        Write-Host "  [STL] FAILED" -ForegroundColor Red
        $anyFailed = $true
    }

    # --- PNG ---
    if ($RenderPng) {
        if (Test-Path $pngFile) { Remove-Item -LiteralPath $pngFile -Force }
        & $osPath @(
            "-o",           $pngFile,
            "--imgsize",    "1024,1024",
            "--colorscheme","Cornfield",
            "--viewall",
            "--autocenter",
            "--enable",     "all",
            $scadFile.FullName
        )
        if (Test-Path $pngFile) {
            Write-Host "  [PNG] OK -> $pngFile" -ForegroundColor Green
        } else {
            Write-Host "  [PNG] FAILED" -ForegroundColor Red
            $anyFailed = $true
        }
    }
}

Write-Host "--- All Processes Complete ---" -ForegroundColor Cyan
if ($anyFailed) { exit 1 }
