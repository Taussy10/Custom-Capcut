# Custom-Capcut 🎬

> A mod collection for **JianyingPro (剪映专业版)** — English translation + video processing scripts.

JianyingPro is a powerful video editor by ByteDance (same company as TikTok/CapCut).  
This repo contains modifications to make it more usable for English speakers, plus utility scripts for video processing.

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
git clone https://github.com/Taussy10/Custom-Capcut.git
cd Custom-Capcut
```

### 2. Apply the English translation
```powershell
# Change this path to where YOUR JianyingPro is installed
$jianyingPath = "E:\Tausif\Softwares\JianyingPro"

# Set source and destination
$src  = ".\translation\zh-Hans.po"
$dest = "$jianyingPath\5.5.0.11332\Resources\po\zh-Hans.po"

# Backup the original first (IMPORTANT)
Copy-Item $dest "$dest.bak" -Force
Write-Host "Backup created!" -ForegroundColor Green

# Apply English translation
Copy-Item $src $dest -Force
Write-Host "English translation applied! Launch JianyingPro now." -ForegroundColor Cyan
```

### 3. Revert back to Chinese (if needed)
```powershell
# Change this path to where YOUR JianyingPro is installed
$jianyingPath = "E:\Tausif\Softwares\JianyingPro"

$dest   = "$jianyingPath\5.5.0.11332\Resources\po\zh-Hans.po"
$backup = "$dest.bak"

Copy-Item $backup $dest -Force
Write-Host "Reverted to Chinese successfully!" -ForegroundColor Green
```

### 4. Pull latest updates from this repo
```powershell
# Run this whenever new scripts or translation improvements are pushed
cd Custom-Capcut
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
| `scripts\REVERT_TO_CHINESE.ps1` | Reverts back to Chinese UI |

---

## 🛠️ Planned Features

- [ ] Silence Remover — auto-cuts silent parts from video using ffmpeg
- [ ] Noise Reducer — removes background hiss from audio
- [ ] Auto-crop — converts 16:9 video to 9:16 for Reels/Shorts
- [ ] Speed Changer — make video faster or slower
- [ ] Python script plugin system — drop any `.py` script and run it on videos

### How future scripts will work (PowerShell)
```powershell
# Example: once silence remover is added
$video = "C:\Users\YourName\Videos\myvideo.mp4"
.\scripts\silence_remover.ps1 -InputVideo $video
# Output: myvideo_no_silence.mp4 in same folder
```

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

This repo contains **only modifications and scripts** — not the JianyingPro application itself.  
JianyingPro is owned by ByteDance. Use this at your own risk.

---

## 📝 Notes

- Translation covers JianyingPro version **5.5.0.11332**
- ffmpeg is already bundled inside JianyingPro — our scripts use it directly, no extra install needed
- Some UI labels may look slightly technical — translation improvements are planned
