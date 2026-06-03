# =====================================================
# JianyingPro - REVERT to Chinese UI
# Run this script to undo the English translation
# =====================================================

$JIANYING_PATH = "E:\Tausif\Softwares\JianyingPro"   # <-- Change this if needed

if (-not (Test-Path $JIANYING_PATH)) {
    Write-Host "ERROR: JianyingPro folder not found at: $JIANYING_PATH" -ForegroundColor Red
    pause; exit
}

# Find all version directories (e.g. 8.9.0.13361)
$versionDirs = Get-ChildItem -Path $JIANYING_PATH -Directory | Where-Object { $_.Name -match '^\d+(\.\d+)+$' }

if ($versionDirs.Count -eq 0) {
    Write-Host "ERROR: No version directories found in: $JIANYING_PATH" -ForegroundColor Red
    pause; exit
}

$revertedCount = 0
foreach ($dir in $versionDirs) {
    $destDir = Join-Path $dir.FullName "Resources\po"
    $poFile  = Join-Path $destDir "zh-Hans.po"
    $backupFile = "$poFile.bak"

    if (Test-Path $backupFile) {
        Copy-Item -Path $backupFile -Destination $poFile -Force
        Write-Host "REVERTED successfully for version $($dir.Name)! App is back to Chinese." -ForegroundColor Green
        Write-Host "Backup file kept at: $backupFile" -ForegroundColor Gray
        $revertedCount++
    }
}

if ($revertedCount -eq 0) {
    Write-Host "ERROR: Backup files not found. Cannot revert." -ForegroundColor Red
    pause; exit
}
pause

