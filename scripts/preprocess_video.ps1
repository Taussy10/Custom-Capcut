# ============================================================
# Custom Video Editor - Video Pre-Processor
# How to use:
#   Option 1: Right-click this file -> "Run with PowerShell"
#   Option 2: Drag your video file onto this script
#   Output saves in the SAME folder as your input video
# ============================================================

$ffmpeg = "E:\Tausif\Softwares\JianyingPro\5.5.0.11332\ffmpeg.exe"

# Check ffmpeg exists
if (-not (Test-Path $ffmpeg)) {
    Write-Host "ERROR: ffmpeg not found at: $ffmpeg" -ForegroundColor Red
    Write-Host "Update the ffmpeg path in this script." -ForegroundColor Yellow
    pause; exit
}

Clear-Host
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Custom Video Editor - Pre-Processor     " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# ---- Get input video path ----
if ($args.Count -gt 0) {
    $inputVideo = $args[0].Trim('"')
} else {
    Write-Host "Enter your video path (or drag the video file onto this script next time):" -ForegroundColor Yellow
    Write-Host "Example: C:\Users\YourName\Videos\myvideo.mp4" -ForegroundColor Gray
    Write-Host ""
    $inputVideo = Read-Host "Video path"
    $inputVideo = $inputVideo.Trim('"')
}

if (-not (Test-Path $inputVideo)) {
    Write-Host ""
    Write-Host "ERROR: Video not found at: $inputVideo" -ForegroundColor Red
    pause; exit
}

$videoInfo = Get-Item $inputVideo
$folder    = $videoInfo.DirectoryName
$baseName  = $videoInfo.BaseName
$ext       = $videoInfo.Extension

Write-Host ""
Write-Host "Video found: $($videoInfo.Name)  ($([math]::Round($videoInfo.Length/1MB, 2)) MB)" -ForegroundColor Green
Write-Host ""

# ---- Select operations ----
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " What do you want to do?                   " -ForegroundColor Cyan
Write-Host " (Enter number. For multiple, use comma    " -ForegroundColor Cyan
Write-Host "  e.g. 1,2 or 1,2,3)                      " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host " [1] Silence Remove    - cut out silent gaps automatically" -ForegroundColor White
Write-Host " [2] Noise Reduce      - remove background hiss/noise from audio" -ForegroundColor White
Write-Host " [3] Compress          - reduce file size (re-encodes video)" -ForegroundColor White
Write-Host " [4] Speed 2x          - make video play at double speed" -ForegroundColor White
Write-Host " [5] Speed 0.5x        - make video play in slow motion" -ForegroundColor White
Write-Host " [6] Reels Crop (9:16) - crop horizontal video to vertical (Shorts/Reels)" -ForegroundColor White
Write-Host " [7] Trim              - extract a specific portion of the video" -ForegroundColor White
Write-Host " [8] All-in-one        - apply Silence Remove + Noise Reduce + Compress together" -ForegroundColor White
Write-Host ""

$choice  = Read-Host "Your choice"
$choices = $choice -split ',' | ForEach-Object { $_.Trim() }

# ---- Build argument lists ----
$audioFilters = [System.Collections.Generic.List[string]]::new()
$videoFilters = [System.Collections.Generic.List[string]]::new()
$suffix       = ""
$trimStart    = ""
$trimDuration = ""

# Handle all-in-one
if ($choices -contains "8") { $choices = @("1","2","3") }

# Handle trim
if ($choices -contains "7") {
    Write-Host ""
    Write-Host "Trim settings:" -ForegroundColor Yellow
    $trimStart    = Read-Host "Start time in seconds (e.g. 0)"
    $trimDuration = Read-Host "Duration in seconds (e.g. 30)"
    $suffix += "_trimmed"
}

if ($choices -contains "1") {
    $audioFilters.Add("silenceremove=start_periods=1:start_threshold=-50dB:stop_periods=-1:stop_threshold=-50dB:stop_duration=0.3")
    $suffix += "_nosilence"
}
if ($choices -contains "2") {
    $audioFilters.Add("anlmdn=s=7:p=0.002")
    $suffix += "_clean"
}
if ($choices -contains "4") {
    $videoFilters.Add("setpts=0.5*PTS")
    $audioFilters.Add("atempo=2.0")
    $suffix += "_2x"
}
if ($choices -contains "5") {
    $videoFilters.Add("setpts=2.0*PTS")
    $audioFilters.Add("atempo=0.5")
    $suffix += "_slowmo"
}
if ($choices -contains "6") {
    $videoFilters.Add("crop=ih*9/16:ih")
    $suffix += "_reels"
}

# ---- Build output path ----
$outputVideo = Join-Path $folder "$baseName$suffix$ext"

# ---- Build ffmpeg argument array (FIXED - each arg is separate) ----
$ffArgs = [System.Collections.Generic.List[string]]::new()

# Trim args (must come before -i)
if ($trimStart -ne "") {
    $ffArgs.Add("-ss"); $ffArgs.Add($trimStart)
    $ffArgs.Add("-t");  $ffArgs.Add($trimDuration)
}

$ffArgs.Add("-i"); $ffArgs.Add($inputVideo)

# Audio filters
if ($audioFilters.Count -gt 0) {
    $ffArgs.Add("-af"); $ffArgs.Add($audioFilters -join ',')
}

# Video filters
if ($videoFilters.Count -gt 0) {
    $ffArgs.Add("-vf"); $ffArgs.Add($videoFilters -join ',')
}

# Compress (FIXED - proper H.264 re-encode with target bitrate)
if ($choices -contains "3") {
    $origSizeMB = [math]::Round($videoInfo.Length / 1MB, 2)
    Write-Host ""
    Write-Host "Current size: $origSizeMB MB" -ForegroundColor Yellow
    Write-Host "How much do you want to compress?" -ForegroundColor Yellow
    Write-Host " [1] Light  - best quality, ~20% smaller" -ForegroundColor White
    Write-Host " [2] Medium - good quality, ~50% smaller  (recommended)" -ForegroundColor White
    Write-Host " [3] Heavy  - lower quality, ~70% smaller" -ForegroundColor White
    $compChoice = Read-Host "Choice"
    $crf = switch ($compChoice) {
        "1" { "23" }
        "3" { "35" }
        default { "28" }
    }
    $ffArgs.Add("-c:v"); $ffArgs.Add("libx264")
    $ffArgs.Add("-crf"); $ffArgs.Add($crf)
    $ffArgs.Add("-preset"); $ffArgs.Add("medium")
    $ffArgs.Add("-c:a"); $ffArgs.Add("aac")
    $ffArgs.Add("-b:a"); $ffArgs.Add("128k")
    $suffix += "_compressed"
    # Update output path with new suffix
    $outputVideo = Join-Path $folder "$baseName$suffix$ext"
}

$ffArgs.Add("-y"); $ffArgs.Add($outputVideo)

# ---- Show summary ----
Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Processing..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Input  : $($videoInfo.Name)" -ForegroundColor White
Write-Host " Output : $(Split-Path $outputVideo -Leaf)" -ForegroundColor White
Write-Host " Folder : $folder" -ForegroundColor Gray
Write-Host ""

# ---- Run ffmpeg ----
& $ffmpeg $ffArgs 2>&1 | ForEach-Object {
    if ($_ -match 'time=') {
        Write-Host "`r  Progress: $_" -NoNewline -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host ""

# ---- Result ----
if (Test-Path $outputVideo) {
    $outInfo   = Get-Item $outputVideo
    $origSize  = [math]::Round($videoInfo.Length / 1MB, 2)
    $newSize   = [math]::Round($outInfo.Length / 1MB, 2)
    $reduction = [math]::Round((1 - $outInfo.Length / $videoInfo.Length) * 100, 1)

    Write-Host "============================================" -ForegroundColor Green
    Write-Host " DONE! Video processed successfully!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host " Saved at : $outputVideo" -ForegroundColor White
    Write-Host " Before   : $origSize MB" -ForegroundColor White
    Write-Host " After    : $newSize MB  ($reduction% smaller)" -ForegroundColor White
    Write-Host ""
    Write-Host " You can now import this video into your editor!" -ForegroundColor Cyan
} else {
    Write-Host "ERROR: Output was not created. Check the error messages above." -ForegroundColor Red
}

Write-Host ""
pause
