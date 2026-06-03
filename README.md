# 🎬 Custom-Capcut Toolkit

> A collection of PowerShell tools for video editing automation — captions, preprocessing, and app translation. No coding needed, just right-click and run.

---

## 🧰 Tools Overview

| Tool | Script | What it does |
|------|--------|--------------|
| 🎤 Auto Captions | `scripts/add_captions.ps1` | AI-powered karaoke captions burned into video |
| 🎙️ Audio Captions | `scripts/generate_audio_captions.ps1` | AI-powered SRT subtitles generated from audio files |
| 🎬 Video Pre-Processor | `scripts/preprocess_video.ps1` | Silence remove, noise reduce, compress, crop, trim, speed |
| 🌐 Apply English UI | `scripts/APPLY_ENGLISH.ps1` | Switch JianyingPro UI to English |
| 🔄 Revert to Chinese | `scripts/REVERT_TO_CHINESE.ps1` | Undo English translation, go back to original |

---

## 📖 Detailed Docs

Each tool has its own README with full instructions:

| Tool | README |
|------|--------|
| 🎤 Auto Captions | [docs/add_captions.md](docs/add_captions.md) |
| 🎙️ Audio Captions | [docs/generate_audio_captions.md](docs/generate_audio_captions.md) |
| 🎬 Video Pre-Processor | [docs/preprocess_video.md](docs/preprocess_video.md) |
| 🌐 Apply English UI | [docs/apply_english.md](docs/apply_english.md) |
| 🔄 Revert to Chinese | [docs/revert_to_chinese.md](docs/revert_to_chinese.md) |

---

## ⚡ Quick Start

### Step 1 — Clone the repo
```powershell
git clone https://github.com/Taussy10/Custom-Video-Editor.git
cd Custom-Video-Editor
```

### Step 2 — Run any tool
```
📁 Open: scripts\
📄 Right-click any .ps1 file
▶️ Click: Run with PowerShell
```

### Step 3 — Pull latest updates
```powershell
git pull origin main
```

---

## 📋 Requirements

| Requirement | Used by | Install |
|-------------|---------|--------|
| ffmpeg | Pre-Processor, Captions | `winget install Gyan.FFmpeg` |
| Python 3.11+ | Auto Captions | [python.org](https://www.python.org/downloads/) |
| openai-whisper | Auto Captions | `pip install openai-whisper` |
| JianyingPro | Translation scripts | Install separately |

---

## 🛠️ Planned Features

- [x] Auto Karaoke Captions — AI transcription + red word highlight + watermark
- [x] Silence Remover — auto-cuts silent parts
- [x] Noise Reducer — removes background hiss
- [x] Compress — reduces file size
- [x] Speed Changer — 2x / 0.5x
- [x] Reels Crop — 16:9 to 9:16
- [x] Trim — extract clip
- [x] English UI Translation for JianyingPro
- [ ] Drag & drop GUI app
- [ ] Python plugin system

---

## ⚠️ Disclaimer

This repo contains **only scripts and modifications** — not the application itself.  
Use at your own risk.

---

## 📝 Notes

- Translation scripts automatically detect and support any installed version of JianyingPro (tested on **8.9.0.13361** and **5.5.0.11332**)
- ffmpeg must be installed separately and in your system PATH
- Whisper AI model downloads once (~140MB) on first caption run
