# ============================================================
#  remove-watermark-generator.ps1  —  Auto Watermark Remover
#  Part of Custom-Capcut scripts collection
#  Usage: Right-click → Run with PowerShell
# ============================================================

$ErrorActionPreference = "Stop"

trap {
    Write-Host ""
    Write-Host "[-] AN ERROR OCCURRED:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    pause
    exit 1
}

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "         Auto Watermark Remover" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# -- Check dependencies ------------------------------------------------------
Write-Host "Checking for opencv-python dependency..." -ForegroundColor Gray
$prevError = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$pythonCheck = python -c "import cv2" 2>&1
$exitCode = $LASTEXITCODE
$ErrorActionPreference = $prevError

if ($exitCode -ne 0) {
    Write-Host "Installing opencv-python..." -ForegroundColor Yellow
    pip install opencv-python --quiet
    Write-Host "Installed successfully!" -ForegroundColor Green
} else {
    Write-Host "opencv-python is already installed." -ForegroundColor Green
}
Write-Host ""

# -- Step 1: Get Video path --------------------------------------------------
$videoPath = Read-Host "Enter your VIDEO path (or drag & drop)"
$videoPath = $videoPath.Trim('"')

if (-not (Test-Path $videoPath)) {
    Write-Host "[-] Video File not found: $videoPath" -ForegroundColor Red
    pause
    exit 1
}

# -- Step 2: Get Watermark Image path ----------------------------------------
$templatePath = Read-Host "Enter your WATERMARK IMAGE path (or drag & drop)"
$templatePath = $templatePath.Trim('"')

if (-not (Test-Path $templatePath)) {
    Write-Host "[-] Template File not found: $templatePath" -ForegroundColor Red
    pause
    exit 1
}

$directory = Split-Path $videoPath -Parent
$filename = [System.IO.Path]::GetFileNameWithoutExtension($videoPath)
$extension = [System.IO.Path]::GetExtension($videoPath)
$outputPath = Join-Path $directory "$($filename)_nowatermark$extension"

Write-Host ""
Write-Host "Video     : $videoPath" -ForegroundColor Gray
Write-Host "Template  : $templatePath" -ForegroundColor Gray
Write-Host "Output    : $outputPath" -ForegroundColor Gray
Write-Host ""

# -- Step 3: Run Python script to locate watermark ---------------------------
Write-Host "Locating watermark in video..." -ForegroundColor Yellow

# Dynamically generate the Python script
$pythonCode = @"
import cv2
import sys
import os
import argparse
import subprocess

def extract_frame(video_path, output_path):
    cmd = ['ffmpeg', '-i', video_path, '-vframes', '1', '-q:v', '2', output_path, '-y']
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def find_watermark(frame_path, template_path):
    img = cv2.imread(frame_path)
    template = cv2.imread(template_path)
    if img is None or template is None:
        return None
    result = cv2.matchTemplate(img, template, cv2.TM_CCOEFF_NORMED)
    min_val, max_val, min_loc, max_loc = cv2.minMaxLoc(result)
    x, y = max_loc
    h, w = template.shape[:2]
    return x, y, w, h

if __name__ == '__main__':
    video_path = sys.argv[1]
    template_path = sys.argv[2]
    
    frame_path = 'temp_frame.jpg'
    extract_frame(video_path, frame_path)
    
    coords = find_watermark(frame_path, template_path)
    
    if os.path.exists(frame_path):
        os.remove(frame_path)
        
    if coords:
        print(f"{coords[0]},{coords[1]},{coords[2]},{coords[3]}")
    else:
        print("ERROR: Could not locate watermark")
        sys.exit(1)
"@

$tempPythonFile = Join-Path $env:TEMP "temp_find_watermark.py"
$pythonCode | Out-File -FilePath $tempPythonFile -Encoding utf8

$output = python $tempPythonFile "$videoPath" "$templatePath"

# Cleanup temp Python script
if (Test-Path $tempPythonFile) { Remove-Item $tempPythonFile }

if ($LASTEXITCODE -ne 0 -or $output -match "ERROR") {
    Write-Error "Failed to locate watermark. Ensure the template matches exactly."
    pause
    exit 1
}

$coords = $output.Trim() -split ","
if ($coords.Length -ne 4) {
    Write-Error "Unexpected output from python script: $output"
    pause
    exit 1
}

$x = $coords[0]
$y = $coords[1]
$w = $coords[2]
$h = $coords[3]

Write-Host "Watermark found at X:$x, Y:$y (Width:$w, Height:$h)" -ForegroundColor Green
Write-Host "Applying blur filter with ffmpeg... Please wait." -ForegroundColor Yellow

# -- Step 4: Run ffmpeg ------------------------------------------------------
$ffmpegArgs = @(
    "-v", "error",
    "-stats",
    "-i", $videoPath,
    "-vf", "delogo=x=${x}:y=${y}:w=${w}:h=${h}",
    "-c:a", "copy",
    $outputPath,
    "-y"
)

& ffmpeg @ffmpegArgs

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "============================================" -ForegroundColor Green
    Write-Host "   SUCCESS!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Watermark removed successfully!" -ForegroundColor White
    Write-Host "Output saved to: $outputPath" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Error "Failed to remove watermark with ffmpeg."
}

pause
