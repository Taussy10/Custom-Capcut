# Custom Video Editor 🎬

> A mod collection for a powerful video editor — English translation + video processing scripts.

This repo contains modifications to improve the editor for English speakers, plus utility scripts for video processing.

---

## 📦 What's Inside

| Folder | Contents |
|--------|----------|
| `translation/` | English UI translation file (`zh-Hans.po`) |
| `scripts/` | Utility scripts — silence remover, revert tool, etc. |

---

## ⚡ Quick Start (PowerShell — do this first)

Open PowerShell and run these commands one by one:

### 1. Clone the repo
```powershell
git clone https://github.com/Taussy10/Custom-Video-Editor.git
cd Custom-Video-Editor
```

### 2. Apply the English translation
```powershell
# Change this path to where YOUR app is installed
$appPath = "C:\Path\To\Your\VideoEditor"

# Set source and destination
$src  = ".\translation\zh-Hans.po"
$dest = "$appPath\5.5.0.11332\Resources\po\zh-Hans.po"

# Backup the original first (IMPORTANT)
Copy-Item $dest "$dest.bak" -Force
Write-Host "Backup created!" -ForegroundColor Green

# Apply English translation
Copy-Item $src $dest -Force
Write-Host "English translation applied! Launch the app now." -ForegroundColor Cyan
```

### 3. Revert back to original (if needed)
```powershell
# Change this path to where YOUR app is installed
$appPath = "C:\Path\To\Your\VideoEditor"

$dest   = "$appPath\5.5.0.11332\Resources\po\zh-Hans.po"
$backup = "$dest.bak"

Copy-Item $backup $dest -Force
Write-Host "Reverted successfully!" -ForegroundColor Green
```

### 4. Pull latest updates from this repo
```powershell
# Run this whenever new scripts or translation improvements are pushed
cd Custom-Video-Editor
git pull origin main
Write-Host "Repo updated!" -ForegroundColor Green
```

### 5. Check what changed in latest update
```powershell
git log --oneline -10
```

---

## 🖱️ One-Click Scripts (Alternative to PowerShell)

If you don't want to type commands, just right-click these files → **Run with PowerShell**:

| Script | What it does |
|--------|-------------|
| `scripts\APPLY_ENGLISH.ps1` | Applies the English translation |
| `scripts\REVERT_TO_CHINESE.ps1` | Reverts back to original UI |
| `scripts\preprocess_video.ps1` | Pre-process any video before editing |
| `scripts\add_captions.ps1` | Auto karaoke captions — red active word, optional watermark |

---

## 🎬 Video Pre-Processor

Pre-process your video **before** importing it into the editor to clean it up, reduce size, or remove silence.

### How to use (No commands needed)

**Step 1 — Find your video file**
Go to wherever your video is saved (Downloads, Desktop, any folder)
For video video editor in this -> E:\Tausif\Softwares\JianyingPro Drafts\PROJECT-NAME\Resources\combination

**Step 2 — Go in the script folder Right-click the script → Run with PowerShell**
```
📁 Open: scripts\
📄 Right-click: preprocess_video.ps1
▶️ Click: Run with PowerShell
```

**Step 3 — Enter your video path**

The video that you found -> Right-click your video file → **Copy as path** -> It will be copied

When the Terminal opens, it will ask:
```
Enter your video path:
```
paste the path of your video 

**Step 4 — Pick what you want to do**
```
[1] Silence Remove    - cut out silent gaps automatically
[2] Noise Reduce      - remove background hiss/noise from audio
[3] Compress          - reduce file size
[4] Speed 2x          - double speed
[5] Speed 0.5x        - slow motion
[6] Reels Crop (9:16) - crop horizontal to vertical for Shorts/Reels
[7] Trim              - extract a specific part of the video
[8] All-in-one        - Silence Remove + Noise Reduce + Compress together
```
Type a number (or multiple numbers with comma e.g. `1,2`) → press Enter → Done ✅

### Where does the output save?

**Same folder as your original video**, with a label added to the name:

| Operation | Output filename |
|-----------|----------------|
| Silence Remove | `myvideo_nosilence.mp4` |
| Noise Reduce | `myvideo_clean.mp4` |
| Compress | `myvideo_compressed.mp4` |
| All-in-one | `myvideo_nosilence_clean_compressed.mp4` |

### What does pre-processing actually do?

| Without Pre-processing | With Pre-processing |
|----------------------|-------------------|
| Awkward silences in video | Auto-cut — video feels tight |
| Background fan/AC noise | Clean audio |
| Large file size (slow upload) | Smaller file, faster upload |
| Horizontal video | Vertical — ready for Reels/Shorts |

> **Note:** Pre-processing happens BEFORE you import into the editor. It does NOT unlock any paid effects inside the editor.

---

## 🎤 Auto Karaoke Caption Generator

Auto-transcribes your video using AI (Whisper) and burns **karaoke-style captions** directly into the video — active word highlights in **red** as it's spoken.

### Requirements

> Make sure these are installed before running:
- [Python 3.11+](https://www.python.org/downloads/) — `python --version` to check
- Whisper — install with: `pip install openai-whisper`
- ffmpeg — must be in your system PATH

### How to use

**Step 1 — Right-click the script → Run with PowerShell**
```
📁 Open: scripts\
📄 Right-click: add_captions.ps1
▶️ Click: Run with PowerShell
```

**Step 2 — Enter your video path**
```
Enter your video path (or drag & drop):
```
Right-click your video → **Copy as path** → paste it → press Enter

**Step 3 — Optional watermark**
```
Add watermark text? (e.g. @geodiary10) — leave blank to skip:
```
Type your handle (e.g. `@geodiary10`) or just press Enter to skip

**Step 4 — Wait ~1 minute**

The script will:
1. 🔊 Extract audio from video
2. 🧠 Transcribe with Whisper AI (~30s)
3. 📝 Generate karaoke captions (red active word)
4. 🎬 Burn captions + watermark into final video
5. 🧹 Clean up all temp files automatically

### Output

**Same folder as your original video:**

| Input | Output |
|-------|--------|
| `myvideo.mp4` | `myvideo_captioned.mp4` |

### What the captions look like

| Feature | Detail |
|---------|--------|
| Style | Karaoke — full line shown, active word highlighted |
| Active word color | 🔴 Red + Bold |
| Inactive words | ⬜ White |
| Font | Arial Bold, 72px |
| Position | Bottom center (above safe zone) |
| Words per line | Max 6 words or 3.5s per line |
| Watermark | Optional — top right corner, semi-transparent |

> **Note:** First run may take longer as Whisper downloads the AI model (~140MB, one time only)

---

## 🛠️ Planned Features

- [x] Silence Remover — auto-cuts silent parts from video
- [x] Noise Reducer — removes background hiss from audio
- [x] Compress — reduces file size with quality control
- [x] Speed Changer — 2x fast or 0.5x slow motion
- [x] Reels Crop — 16:9 to 9:16 for Shorts/Reels
- [x] Trim — extract specific clip from video
- [x] Auto Karaoke Captions — AI transcription + red word highlight + watermark
- [ ] Python script plugin system — drop any `.py` script and run it on videos
- [ ] Drag & drop GUI app

---

## 🔄 Contributing / Adding Your Own Scripts

Want to add a new video processing script?

```powershell
# 1. Pull latest first
git pull origin main

# 2. Add your script to the scripts folder
# scripts\my_new_script.ps1

# 3. Commit and push
git add .
git commit -m "Add: my new script description"
git push origin main
```

---

## ⚠️ Disclaimer

This repo contains **only modifications and scripts** — not the application itself.  
Use this at your own risk.

---

## 📝 Notes

- Translation covers app version **5.5.0.11332**
- ffmpeg is already bundled inside the app — our scripts use it directly, no extra install needed
- Some UI labels may look slightly technical — translation improvements are planned
