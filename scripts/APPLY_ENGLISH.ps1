# =====================================================
# Apply English Translation to JianyingPro
# Edit JIANYING_PATH below to match your install folder
# Then right-click → Run with PowerShell
# =====================================================

$JIANYING_PATH = "E:\Tausif\Softwares\JianyingPro"   # <-- Change this if needed
$src    = Join-Path $PSScriptRoot "..\translation\zh-Hans.po"

if (-not (Test-Path $JIANYING_PATH)) {
    Write-Host "ERROR: JianyingPro folder not found at: $JIANYING_PATH" -ForegroundColor Red
    Write-Host "Please edit the JIANYING_PATH variable in this script." -ForegroundColor Yellow
    pause; exit
}

# Find all version directories (e.g. 8.9.0.13361)
$versionDirs = Get-ChildItem -Path $JIANYING_PATH -Directory | Where-Object { $_.Name -match '^\d+(\.\d+)+$' }

if ($versionDirs.Count -eq 0) {
    Write-Host "ERROR: No version directories found in: $JIANYING_PATH" -ForegroundColor Red
    pause; exit
}

$appliedCount = 0
foreach ($dir in $versionDirs) {
    $destDir = Join-Path $dir.FullName "Resources\po"
    $dest    = Join-Path $destDir "zh-Hans.po"
    $backup  = "$dest.bak"

    if (Test-Path $destDir) {
        # Backup original if not already backed up
        if (-not (Test-Path $backup) -and (Test-Path $dest)) {
            Copy-Item $dest $backup -Force
            Write-Host "Backup created: $backup" -ForegroundColor Green
        }

        # Apply translation
        Copy-Item $src $dest -Force
        Write-Host "English translation applied successfully to version $($dir.Name)!" -ForegroundColor Green
        $appliedCount++
    }
}

if ($appliedCount -eq 0) {
    Write-Host "ERROR: Could not find any 'Resources\po' folder in the version directories." -ForegroundColor Red
    pause; exit
}

Write-Host "Launch JianyingPro to see the English UI." -ForegroundColor Cyan
pause

