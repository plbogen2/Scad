param(
    [switch]$RenderPng = $false
)

$ScriptRoot = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent -LiteralPath $MyInvocation.MyCommand.Path }

# Auto-discover every subdirectory that has an export.ps1 (same logic as CI)
$scripts = Get-ChildItem -Path $ScriptRoot -Recurse -Depth 2 -Filter "export.ps1" |
           Where-Object { $_.FullName -ne "$ScriptRoot\export-all.ps1" -and $_.DirectoryName -ne $ScriptRoot } |
           Sort-Object FullName

if ($scripts.Count -eq 0) {
    Write-Host "No export.ps1 files found in subdirectories." -ForegroundColor Yellow
    exit 0
}

$failed = @()

foreach ($script in $scripts) {
    $project = Split-Path -Leaf $script.DirectoryName
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host " Project: $project" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    if ($RenderPng) {
        & $script.FullName -RenderPng
    } else {
        & $script.FullName
    }

    if ($LASTEXITCODE -ne 0) { $failed += $project }
}

Write-Host ""
if ($failed.Count -gt 0) {
    Write-Host "FAILED: $($failed -join ', ')" -ForegroundColor Red
    exit 1
} else {
    Write-Host "All projects exported successfully." -ForegroundColor Green
}
