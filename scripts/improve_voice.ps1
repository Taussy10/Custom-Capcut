# ============================================================
# Custom Video Editor - Voice Improver (Audio Enhancer)
# How to use:
#   Option 1: Right-click this file -> "Run with PowerShell"
#   Option 2: Drag your video/audio file onto this script
#   Output saves in the SAME folder as your input file
# ============================================================

# Refresh PATH so newly installed ffmpeg is found
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

$ffmpeg = "ffmpeg"

# Check ffmpeg is available
$ffmpegCheck = Get-Command ffmpeg -ErrorAction SilentlyContinue
if (-not $ffmpegCheck) {
    Write-Host "ERROR: ffmpeg not found on your system." -ForegroundColor Red
    Write-Host "Install it by running:  winget install Gyan.FFmpeg" -ForegroundColor Yellow
    pause; exit
}

Clear-Host
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "     Custom Video Editor - Voice Improver   " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# ---- Get input file path ----
if ($args.Count -gt 0) {
    $inputFile = $args[0].Trim('"')
} else {
    Write-Host "Enter your video or audio path (or drag it onto this script):" -ForegroundColor Yellow
    Write-Host "Example: C:\Users\YourName\Videos\interview.mp4" -ForegroundColor Gray
    Write-Host ""
    $inputFile = Read-Host "File path"
    $inputFile = $inputFile.Trim('"')
}

if (-not (Test-Path $inputFile)) {
    Write-Host ""
    Write-Host "ERROR: File not found at: $inputFile" -ForegroundColor Red
    pause; exit
}

$fileInfo = Get-Item $inputFile
$folder    = $fileInfo.DirectoryName
$baseName  = $fileInfo.BaseName
$ext       = $fileInfo.Extension

Write-Host ""
Write-Host "File found: $($fileInfo.Name) ($([math]::Round($fileInfo.Length/1MB, 2)) MB)" -ForegroundColor Green
Write-Host ""

# ---- Select Voice Profile ----
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Choose a Voice Improvement Profile:        " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host " [1] Deep Studio Voice (Recommended)" -ForegroundColor White
Write-Host "     - Deep radio bass boost, heavy voiceover compressor, crisp high-end" -ForegroundColor Gray
Write-Host " [2] Balanced Clear Vocal" -ForegroundColor White
Write-Host "     - Cleans hiss, normalizes loudness, boosts standard speech clarity" -ForegroundColor Gray
Write-Host " [3] Extreme Noise Cleanup" -ForegroundColor White
Write-Host "     - Extra strong denoiser for heavy background wind/AC/fans" -ForegroundColor Gray
Write-Host ""

$profileChoice = Read-Host "Choice (1-3)"
if ($profileChoice -match "^[1-3]$") {
    $profile = $profileChoice
} else {
    $profile = "1"
}

# ---- Build Audio Filters ----
if ($profile -eq "1") {
    # DEEP STUDIO VOICE PIPELINE:
    # 1. Highpass at 55Hz to preserve deep vocal bass but remove ultra-low rumble
    $filterChain = "highpass=f=55"
    # 2. Moderate noise reduction to prevent voice distortion
    $filterChain += ",afftdn=nr=8:nf=-35"
    # 3. Massive vocal bass shelf boost at 120Hz (+6.5dB)
    $filterChain += ",equalizer=f=120:width_type=q:width=0.7:g=6.5"
    # 4. Cut boxy/muddy lower-mids at 400Hz (-3.0dB)
    $filterChain += ",equalizer=f=400:width_type=q:width=1.0:g=-3.0"
    # 5. Crisp upper-mid presence boost at 3000Hz for speech articulation (+4.0dB)
    $filterChain += ",equalizer=f=3000:width_type=q:width=1.0:g=4.0"
    # 6. High-frequency sheen/air boost at 8000Hz (+2.5dB)
    $filterChain += ",equalizer=f=8000:width_type=q:width=1.0:g=2.5"
    # 7. Heavy Voiceover Compressor (low threshold, higher ratio, fast attack)
    $filterChain += ",acompressor=threshold=-24dB:ratio=5.0:attack=10:release=120:makeup=8"
    # 8. High-density loudness target for web distribution (-14 LUFS, Peak -0.5dB)
    $filterChain += ",loudnorm=I=-14:TP=-0.5:LRA=7"
}
elseif ($profile -eq "2") {
    # BALANCED CLEAR VOCAL PIPELINE:
    $filterChain = "highpass=f=85"
    $filterChain += ",afftdn=nr=10:nf=-30"
    $filterChain += ",equalizer=f=400:width_type=q:width=1.0:g=-2"
    $filterChain += ",equalizer=f=3000:width_type=q:width=1.0:g=3.0"
    $filterChain += ",acompressor=threshold=-18dB:ratio=3.5:attack=15:release=150:makeup=4"
    $filterChain += ",loudnorm=I=-16:TP=-1.5:LRA=11"
}
elseif ($profile -eq "3") {
    # EXTREME NOISE CLEANUP PIPELINE:
    $filterChain = "highpass=f=85"
    $filterChain += ",afftdn=nr=16:nf=-22"
    $filterChain += ",equalizer=f=3000:width_type=q:width=1.0:g=3.5"
    $filterChain += ",acompressor=threshold=-18dB:ratio=3.5:attack=15:release=150:makeup=4"
    $filterChain += ",loudnorm=I=-16:TP=-1.5:LRA=11"
}

# ---- Build Output Path ----
$outputFile = Join-Path $folder "$baseName`_enhanced$ext"

# ---- Build FFmpeg Arguments ----
$ffArgs = @(
    "-i", $inputFile,
    "-af", $filterChain
)

# If it's a video file, copy the video stream without re-encoding to save time and quality
$videoExtensions = @(".mp4", ".mkv", ".mov", ".avi", ".webm")
if ($videoExtensions -contains $ext.ToLower()) {
    $ffArgs += @("-c:v", "copy")
}

$ffArgs += @("-y", $outputFile)

# ---- Run processing ----
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Enhancing Voice... (This will keep video quality same)" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

& $ffmpeg $ffArgs 2>&1 | ForEach-Object {
    if ($_ -match 'time=') {
        Write-Host "`r  Progress: $_" -NoNewline -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host ""

# ---- Result ----
if (Test-Path $outputFile) {
    Write-Host "============================================" -ForegroundColor Green
    Write-Host " SUCCESS! Voice enhanced successfully!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host " Saved at: $outputFile" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "ERROR: Output file could not be created. Check FFmpeg output above." -ForegroundColor Red
}

Write-Host ""
pause
