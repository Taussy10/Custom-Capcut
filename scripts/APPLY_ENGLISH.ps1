# =====================================================
# Apply English Translation to JianyingPro
# Edit JIANYING_PATH below to match your install folder
# Then right-click → Run with PowerShell
# =====================================================

$JIANYING_PATH = "E:\Tausif\Softwares\JianyingPro"   # <-- Change this if needed

$dest   = "$JIANYING_PATH\5.5.0.11332\Resources\po\zh-Hans.po"
$backup = "$dest.bak"
$src    = Join-Path $PSScriptRoot "..\translation\zh-Hans.po"

if (-not (Test-Path $dest)) {
    Write-Host "ERROR: JianyingPro not found at: $JIANYING_PATH" -ForegroundColor Red
    Write-Host "Edit the JIANYING_PATH variable in this script." -ForegroundColor Yellow
    pause; exit
}

# Backup original if not already backed up
if (-not (Test-Path $backup)) {
    Copy-Item $dest $backup -Force
    Write-Host "Backup created: $backup" -ForegroundColor Green
}

# Apply translation
Copy-Item $src $dest -Force
Write-Host "English translation applied successfully!" -ForegroundColor Green
Write-Host "Launch JianyingPro to see the English UI." -ForegroundColor Cyan
pause
