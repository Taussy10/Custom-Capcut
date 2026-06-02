# ============================================================
#  add_captions.ps1  —  Auto Karaoke Caption Generator
#  Part of Custom-Capcut scripts collection
#  Usage: Right-click → Run with PowerShell
# ============================================================

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   🎬 Auto Karaoke Caption Generator" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# ── Step 1: Get video path ────────────────────────────────────────────────────
$videoPath = Read-Host "Enter your video path (or drag & drop)"
$videoPath = $videoPath.Trim('"')

if (-not (Test-Path $videoPath)) {
    Write-Host "❌ File not found: $videoPath" -ForegroundColor Red
    pause
    exit 1
}

$videoDir  = Split-Path $videoPath -Parent
$videoName = [System.IO.Path]::GetFileNameWithoutExtension($videoPath)
$audioPath = Join-Path $videoDir "temp_audio.wav"
$assPath   = Join-Path $videoDir "temp_captions.ass"
$outputPath = Join-Path $videoDir "${videoName}_captioned.mp4"

Write-Host ""
Write-Host "📁 Video  : $videoPath" -ForegroundColor Gray
Write-Host "📁 Output : $outputPath" -ForegroundColor Gray
Write-Host ""

# ── Step 2: Watermark? ────────────────────────────────────────────────────────
$addWatermark = Read-Host "Add watermark text? (e.g. @geodiary10) — leave blank to skip"
$addWatermark = $addWatermark.Trim()

# ── Step 3: Extract audio ─────────────────────────────────────────────────────
Write-Host "🔊 Extracting audio..." -ForegroundColor Yellow
ffmpeg -i "$videoPath" -vn -acodec pcm_s16le -ar 16000 -ac 1 "$audioPath" -y 2>$null
Write-Host "   ✅ Audio extracted" -ForegroundColor Green

# ── Step 4: Transcribe with Whisper ──────────────────────────────────────────
Write-Host "🧠 Transcribing with Whisper (this takes ~30s)..." -ForegroundColor Yellow

$transcriptPath = Join-Path $videoDir "temp_transcript.json"

python -c @"
import whisper, json, sys
model = whisper.load_model('base')
result = model.transcribe(r'$audioPath', word_timestamps=True, verbose=False)
words = []
for seg in result.get('segments', []):
    for w in seg.get('words', []):
        words.append({'word': w['word'].strip(), 'start': round(w['start'],3), 'end': round(w['end'],3)})
out = {'words': words}
with open(r'$transcriptPath', 'w', encoding='utf-8') as f:
    json.dump(out, f, indent=2, ensure_ascii=False)
print('Words:', len(words))
"@

Write-Host "   ✅ Transcription done" -ForegroundColor Green

# ── Step 5: Generate ASS karaoke captions ─────────────────────────────────────
Write-Host "📝 Generating karaoke captions..." -ForegroundColor Yellow

python -c @"
import json

with open(r'$transcriptPath', 'r', encoding='utf-8') as f:
    data = json.load(f)

words = data['words']

def to_ass_time(s):
    h = int(s // 3600)
    m = int((s % 3600) // 60)
    sec = s % 60
    cs = int(round((sec - int(sec)) * 100))
    return f'{h}:{m:02d}:{int(sec):02d}.{cs:02d}'

# Group into lines (max 6 words or 3.5s)
lines = []
current = []
for w in words:
    if current:
        dur = w['end'] - current[0]['start']
        if len(current) >= 6 or dur > 3.5:
            lines.append(current)
            current = []
    current.append(w)
if current:
    lines.append(current)

ass_header = '''[Script Info]
ScriptType: v4.00+
PlayResX: 1080
PlayResY: 1920
ScaledBorderAndShadow: yes

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Karaoke,Arial,72,&H00FFFFFF,&H000000FF,&H00000000,&HAA000000,-1,0,0,0,100,100,2,0,1,4,2,2,60,60,280,1

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
'''

events = []
for line_words in lines:
    for i, active_word in enumerate(line_words):
        parts = []
        for j, w in enumerate(line_words):
            clean = w['word'].replace('{','').replace('}','')
            if j == i:
                parts.append(r'{\c&H0000FF&\b1}' + clean + r'{\c&HFFFFFF&\b0}')
            else:
                parts.append(clean)
        text = ' '.join(parts)
        t_start = to_ass_time(active_word['start'])
        t_end   = to_ass_time(active_word['end'])
        events.append(f'Dialogue: 0,{t_start},{t_end},Karaoke,,0,0,0,,{text}')

with open(r'$assPath', 'w', encoding='utf-8') as f:
    f.write(ass_header + '\n'.join(events))

print('Lines:', len(lines), '| Words:', len(events))
"@

Write-Host "   ✅ Captions generated" -ForegroundColor Green

# ── Step 6: Burn captions (+ optional watermark) into video ──────────────────
Write-Host "🎬 Burning captions into video..." -ForegroundColor Yellow

# Build ffmpeg vf filter
$assFilter = "ass=temp_captions.ass"

if ($addWatermark -ne "") {
    $vfFilter = "${assFilter},drawtext=text='${addWatermark}':fontfile='C\:/Windows/Fonts/arialbd.ttf':fontsize=42:fontcolor=white@0.75:x=w-tw-40:y=40:shadowcolor=black@0.6:shadowx=2:shadowy=2"
} else {
    $vfFilter = $assFilter
}

Push-Location $videoDir
ffmpeg -i "$videoPath" -vf "$vfFilter" -c:a copy "$outputPath" -y 2>$null
Pop-Location

# ── Step 7: Cleanup temp files ────────────────────────────────────────────────
Remove-Item $audioPath    -ErrorAction SilentlyContinue
Remove-Item $transcriptPath -ErrorAction SilentlyContinue
Remove-Item $assPath      -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "   ✅ DONE!" -ForegroundColor Green
Write-Host "============================================" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Output saved to:" -ForegroundColor White
Write-Host "   $outputPath" -ForegroundColor Cyan
Write-Host ""

pause
