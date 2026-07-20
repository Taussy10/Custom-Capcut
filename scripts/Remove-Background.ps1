# ============================================================
#  Remove-Background.ps1  —  Auto AI Background Remover
#  Part of Custom-Capcut scripts collection
#  Usage: Right-click → Run with PowerShell
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "       Auto AI Background Remover" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# -- Check dependencies ------------------------------------------------------
Write-Host "Checking for 'rembg' AI library..." -ForegroundColor Gray
$pythonCheck = python -c "import rembg" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Installing rembg (AI background removal tool)..." -ForegroundColor Yellow
    Write-Host "This might take a minute on the first run as it downloads the model." -ForegroundColor Gray
    pip install rembg[cli] --quiet
    Write-Host "Installed successfully!" -ForegroundColor Green
} else {
    Write-Host "rembg is already installed." -ForegroundColor Green
}
Write-Host ""

# -- Step 1: Get Image path --------------------------------------------------
$imagePath = Read-Host "Enter your IMAGE path (or drag & drop)"
$imagePath = $imagePath.Trim('"')

if (-not (Test-Path $imagePath)) {
    Write-Host "[-] Image File not found: $imagePath" -ForegroundColor Red
    pause
    exit 1
}

$directory = Split-Path $imagePath -Parent
$filename = [System.IO.Path]::GetFileNameWithoutExtension($imagePath)
$outputPath = Join-Path $directory "$($filename)_nobg.png"

Write-Host ""
Write-Host "Input     : $imagePath" -ForegroundColor Gray
Write-Host "Output    : $outputPath" -ForegroundColor Gray
Write-Host ""

# -- Step 2: Run AI background removal ---------------------------------------
Write-Host "Removing background using AI... Please wait." -ForegroundColor Yellow

# Use rembg cli
$rembgArgs = @("i", $imagePath, $outputPath)
& rembg @rembgArgs

if ($LASTEXITCODE -eq 0 -and (Test-Path $outputPath)) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "   SUCCESS!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Background removed successfully!" -ForegroundColor White
    Write-Host "Output saved to: $outputPath" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Error "Failed to remove background."
}

pause
