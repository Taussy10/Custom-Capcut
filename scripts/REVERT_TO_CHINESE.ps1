# =====================================================
# JianyingPro - REVERT to Chinese UI
# Run this script to undo the English translation
# =====================================================

$poFile     = "E:\Tausif\Softwares\JianyingPro\5.5.0.11332\Resources\po\zh-Hans.po"
$backupFile = "$poFile.bak"

if (Test-Path $backupFile) {
    Copy-Item -Path $backupFile -Destination $poFile -Force
    Write-Host "REVERTED successfully! App is back to Chinese." -ForegroundColor Green
    Write-Host "Backup file kept at: $backupFile" -ForegroundColor Gray
} else {
    Write-Host "ERROR: Backup file not found at: $backupFile" -ForegroundColor Red
    Write-Host "Cannot revert." -ForegroundColor Red
}
