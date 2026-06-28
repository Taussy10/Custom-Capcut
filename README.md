# 🎬 Custom-Capcut Toolkit

> A collection of PowerShell tools for video editing automation — captions, preprocessing, and app translation. No coding needed, just right-click and run.

---

## 🧰 Tools Overview

| Tool | Script | What it does |
|------|--------|--------------|
| 🎤 Auto Captions | `scripts/add_captions.ps1` | AI-powered karaoke captions burned into video |
| 🎙️ Audio Timestamps | `scripts/audio_timestamps-generator.ps1` | AI-powered JSON word-level timings and frames for Remotion |
| 🎬 Video Pre-Processor | `scripts/preprocess_video.ps1` | Silence remove, noise reduce, compress, crop, trim, speed |
| 🎙️ Voice Improver | `scripts/improve_voice.ps1` | Pro-vocal EQ, dynamic compression, noise gate, & LUFS normalize |

---

## 📖 Detailed Docs

Each tool has its own README with full instructions:

| Tool | README |
|------|--------|
| 🎤 Auto Captions | [docs/add_captions.md](docs/add_captions.md) |
| 🎙️ Audio Timestamps Generator | [docs/audio_timestamps-generator.md](docs/audio_timestamps-generator.md) |
| 🎬 Video Pre-Processor | [docs/preprocess_video.md](docs/preprocess_video.md) |
| 🎙️ Voice Improver | [docs/improve_voice.md](docs/improve_voice.md) |

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
| ffmpeg | Pre-Processor, Captions, Voice Improver | `winget install Gyan.FFmpeg` |
| Python 3.11+ | Auto Captions, Voice Improver | [python.org](https://www.python.org/downloads/) |
| openai-whisper | Auto Captions | `pip install openai-whisper` |

---

## 🛠️ Planned Features

- [x] Auto Karaoke Captions — AI transcription + red word highlight + watermark
- [x] Silence Remover — auto-cuts silent parts
- [x] Noise Reducer — removes background hiss
- [x] Compress — reduces file size
- [x] Speed Changer — 2x / 0.5x
- [x] Reels Crop — 16:9 to 9:16
- [x] Trim — extract clip
- [x] Voice Improver — pro-vocal EQ, dynamic compression, noise gate, & LUFS normalize
- [ ] Drag & drop GUI app
- [ ] Python plugin system

---

## ⚠️ Disclaimer

This repo contains **only scripts and modifications** — not the application itself.  
Use at your own risk.

---

## 📝 Notes

- ffmpeg must be installed separately and in your system PATH
- Whisper AI model downloads once (~140MB) on first caption run
