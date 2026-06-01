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

## 🌐 Apply the English Translation

### Requirements
- JianyingPro **5.5.0.11332** installed

### Steps

1. **Backup first** (always!):
   ```
   Copy zh-Hans.po → zh-Hans.po.bak
   ```

2. **Copy the translation file** to:
   ```
   <JianyingPro Install Folder>\5.5.0.11332\Resources\po\zh-Hans.po
   ```
   Default path example:
   ```
   E:\Tausif\Softwares\JianyingPro\5.5.0.11332\Resources\po\zh-Hans.po
   ```

3. **Launch JianyingPro** — UI will be in English ✅

### One-click apply (PowerShell)
```powershell
# Edit the path below to match your JianyingPro install location
$dest = "C:\Path\To\JianyingPro\5.5.0.11332\Resources\po\zh-Hans.po"
Copy-Item "translation\zh-Hans.po" $dest -Force
```

---

## ↩️ Revert to Chinese

Run `scripts\REVERT_TO_CHINESE.ps1` — it restores the original Chinese UI instantly.

> ⚠️ Make sure `zh-Hans.po.bak` exists in the `po\` folder before reverting.

---

## 🛠️ Planned Features

- [ ] Silence Remover script (auto-cut silent parts from video using ffmpeg)
- [ ] Noise Reducer
- [ ] Auto-crop (16:9 → 9:16 for Reels/Shorts)
- [ ] Speed Changer
- [ ] Python script plugin system

---

## ⚠️ Disclaimer

This repo contains **only modifications and scripts** — not the JianyingPro application itself.  
JianyingPro is owned by ByteDance. Use this at your own risk.

---

## 📝 Notes

- Translation is based on the internal string keys of JianyingPro 5.5.0.11332
- Some labels may look slightly technical (e.g. internal feature flags) — improvements coming
- ffmpeg is bundled with JianyingPro and is used by the video processing scripts
