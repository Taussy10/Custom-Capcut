# ============================================================
#  audio_timestamps-generator.ps1  —  Audio Timestamps Generator
#  Part of Custom-Capcut scripts collection
#  Usage: Right-click → Run with PowerShell
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "         Audio Timestamps Generator" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# -- Step 1: Get audio path --------------------------------------------------
$audioPath = Read-Host "Enter your audio path (or drag & drop)"
$audioPath = $audioPath.Trim('"')

if (-not (Test-Path $audioPath)) {
    Write-Host "[-] File not found: $audioPath" -ForegroundColor Red
    pause
    exit 1
}

# -- Step 2: Get target FPS for Remotion --------------------------------------
$fpsInput = Read-Host "Enter target FPS for Remotion (default: 30)"
$fpsInput = $fpsInput.Trim()
if ($fpsInput -eq "") { $fps = 30 } else { $fps = [int]$fpsInput }

$audioDir  = Split-Path $audioPath -Parent
$audioName = [System.IO.Path]::GetFileNameWithoutExtension($audioPath)
$jsonPath  = Join-Path $audioDir "timestamp-${audioName}.json"

Write-Host ""
Write-Host "File     : $audioPath" -ForegroundColor Gray
Write-Host "FPS      : $fps" -ForegroundColor Gray
Write-Host "JSON Out : $jsonPath" -ForegroundColor Gray
Write-Host ""

# -- Step 3: Choose Whisper Model ---------------------------------------------
Write-Host "Choose Whisper model size (default is 'small'):" -ForegroundColor Gray
Write-Host "1. tiny   (Fastest, lowest accuracy)" -ForegroundColor Gray
Write-Host "2. base   (Fast, decent accuracy)" -ForegroundColor Gray
Write-Host "3. small  (Medium, better accuracy)" -ForegroundColor Gray
Write-Host "4. medium (Slow, high accuracy)" -ForegroundColor Gray
$modelChoice = Read-Host "Enter choice (1-4) or press Enter for 'small'"

$modelName = "small"
if ($modelChoice -eq "1") { $modelName = "tiny" }
elseif ($modelChoice -eq "2") { $modelName = "base" }
elseif ($modelChoice -eq "3") { $modelName = "small" }
elseif ($modelChoice -eq "4") { $modelName = "medium" }

# -- Step 4: Transcribe and Generate JSON --------------------------------------
Write-Host ""
Write-Host "Transcribing audio with Whisper ($modelName model)..." -ForegroundColor Yellow

$scriptPath = Join-Path $PSScriptRoot "transcribe.py"
python "$scriptPath" "$audioPath" "$fps" "$modelName" "$jsonPath"

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   SUCCESS!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "JSON file saved to:" -ForegroundColor White
Write-Host "   JSON Timestamps: $jsonPath" -ForegroundColor Cyan
Write-Host ""

pause
