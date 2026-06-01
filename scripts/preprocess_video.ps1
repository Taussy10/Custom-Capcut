# ============================================================
# Custom Video Editor - Video Pre-Processor
# Drag your video file onto this script OR run and type path
# Output saves in the SAME folder as your input video
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
Write-Host "   Custom Video Editor - Pre-Processor" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# ---- Get input video path ----
# Support drag-and-drop (script args) OR manual input
if ($args.Count -gt 0) {
    $inputVideo = $args[0].Trim('"')
} else {
    Write-Host "Video ka path daalo (ya file ko is script pe drag karo):" -ForegroundColor Yellow
    Write-Host "Example: C:\Users\Tausif\Videos\myvideo.mp4" -ForegroundColor Gray
    Write-Host ""
    $inputVideo = Read-Host "Path"
    $inputVideo = $inputVideo.Trim('"')
}

if (-not (Test-Path $inputVideo)) {
    Write-Host ""
    Write-Host "ERROR: Video nahi mili: $inputVideo" -ForegroundColor Red
    pause; exit
}

$videoInfo = Get-Item $inputVideo
$folder    = $videoInfo.DirectoryName
$baseName  = $videoInfo.BaseName
$ext       = $videoInfo.Extension

Write-Host ""
Write-Host "Video mili: $($videoInfo.Name)  ($([math]::Round($videoInfo.Length/1MB, 1)) MB)" -ForegroundColor Green
Write-Host ""

# ---- Select operations ----
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Kya karna hai? (number daalo, multiple ke" -ForegroundColor Cyan
Write-Host " liye comma se alag karo  e.g. 1,3,5)     " -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host " [1] Silence Remove    - beech ki chup hatao" -ForegroundColor White
Write-Host " [2] Noise Reduce      - background hiss/noise hatao" -ForegroundColor White
Write-Host " [3] Compress          - file size kam karo (quality thodi kam)" -ForegroundColor White
Write-Host " [4] Speed 2x          - video double speed banao" -ForegroundColor White
Write-Host " [5] Speed 0.5x        - video slow motion banao" -ForegroundColor White
Write-Host " [6] Reels Crop (9:16) - horizontal to vertical crop" -ForegroundColor White
Write-Host " [7] Trim              - video ka ek hissa lo" -ForegroundColor White
Write-Host " [8] Sab kuch          - 1+2+3 ek saath (recommended)" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Choice"
$choices = $choice -split ',' | ForEach-Object { $_.Trim() }

# ---- Build ffmpeg filters ----
$audioFilters = [System.Collections.Generic.List[string]]::new()
$videoFilters = [System.Collections.Generic.List[string]]::new()
$extraArgs    = [System.Collections.Generic.List[string]]::new()
$suffix       = ""

# Trim handling
$trimArgs = ""
if ($choices -contains "7") {
    Write-Host ""
    Write-Host "Trim settings:" -ForegroundColor Yellow
    $startTime = Read-Host "Start time (seconds, e.g. 0)"
    $duration  = Read-Host "Duration (seconds, e.g. 30)"
    $trimArgs  = "-ss $startTime -t $duration"
    $suffix    += "_trimmed"
}

if ($choices -contains "8") { $choices = @("1","2","3") }

if ($choices -contains "1") {
    $audioFilters.Add("silenceremove=start_periods=1:start_threshold=-50dB:stop_periods=-1:stop_threshold=-50dB:stop_duration=0.3")
    $suffix += "_nosilence"
}
if ($choices -contains "2") {
    $audioFilters.Add("anlmdn=s=7:p=0.002")
    $suffix += "_clean"
}
if ($choices -contains "3") {
    $extraArgs.Add("-crf 28 -preset fast")
    $suffix += "_compressed"
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

# ---- Build ffmpeg command ----
$filterArgs = ""
if ($audioFilters.Count -gt 0) {
    $filterArgs += " -af `"" + ($audioFilters -join ',') + "`""
}
if ($videoFilters.Count -gt 0) {
    $filterArgs += " -vf `"" + ($videoFilters -join ',') + "`""
}
$extraStr = if ($extraArgs.Count -gt 0) { " " + ($extraArgs -join ' ') } else { "" }

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Processing shuru ho raha hai..." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Input  : $($videoInfo.Name)" -ForegroundColor White
Write-Host " Output : $(Split-Path $outputVideo -Leaf)" -ForegroundColor White
Write-Host " Folder : $folder" -ForegroundColor Gray
Write-Host ""

$cmd = "$trimArgs -i `"$inputVideo`"$filterArgs$extraStr -y `"$outputVideo`""
$cmdArray = $cmd -split ' (?=(?:[^"]*"[^"]*")*[^"]*$)' | Where-Object { $_ -ne '' }

& $ffmpeg $cmdArray 2>&1 | ForEach-Object {
    if ($_ -match 'time=') {
        Write-Host "`r  Progress: $_" -NoNewline -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host ""

if (Test-Path $outputVideo) {
    $outInfo = Get-Item $outputVideo
    Write-Host "============================================" -ForegroundColor Green
    Write-Host " DONE! Video process ho gayi!" -ForegroundColor Green
    Write-Host "============================================" -ForegroundColor Green
    Write-Host " Saved  : $outputVideo" -ForegroundColor White
    Write-Host " Size   : $([math]::Round($outInfo.Length/1MB, 1)) MB  (was $([math]::Round($videoInfo.Length/1MB, 1)) MB)" -ForegroundColor White
    Write-Host ""
    Write-Host " Ab is video ko editor mein import karo!" -ForegroundColor Cyan
} else {
    Write-Host "ERROR: Output nahi bani. Upar error message dekho." -ForegroundColor Red
}

Write-Host ""
pause
