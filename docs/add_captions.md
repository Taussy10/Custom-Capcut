# 🎤 Auto Karaoke Caption Generator

> Automatically transcribes your video using AI and burns karaoke-style captions into it — active word highlights in **red** as it's spoken.

**Script:** `scripts/add_captions.ps1`

---

## ✅ Requirements

| Requirement | How to install |
|-------------|----------------|
| Python 3.11+ | [python.org/downloads](https://www.python.org/downloads/) |
| openai-whisper | `pip install openai-whisper` |
| ffmpeg | `winget install Gyan.FFmpeg` |

> **First run:** Whisper will download the AI model (~140MB). This only happens once.

---

## 🚀 How to Use

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
Right-click your video → **Copy as path** → paste → press Enter

**Step 3 — Optional watermark**
```
Add watermark text? (e.g. @geodiary10) — leave blank to skip:
```
Type your handle (e.g. `@geodiary10`) or press Enter to skip

**Step 4 — Wait ~1 minute**

The script automatically:
1. 🔊 Extracts audio from video
2. 🧠 Transcribes speech with Whisper AI
3. 📝 Generates karaoke caption file
4. 🎬 Burns captions (+ watermark) into video
5. 🧹 Cleans up all temp files

---

## 📁 Output

Saved in the **same folder as your video**:

| Input | Output |
|-------|--------|
| `myvideo.mp4` | `myvideo_captioned.mp4` |

---

## 🎨 Caption Style

| Feature | Detail |
|---------|--------|
| Style | Karaoke — full line visible, active word highlighted |
| Active word | 🔴 Red + Bold |
| Inactive words | ⬜ White |
| Font | Arial Bold, 72px |
| Position | Bottom center |
| Line length | Max 6 words or 3.5s per line |
| Watermark | Optional — top right, semi-transparent white |

---

## ⚠️ Troubleshooting

| Problem | Fix |
|---------|-----|
| `python not found` | Install Python and check **Add to PATH** during install |
| `ffmpeg not found` | Run `winget install Gyan.FFmpeg` then restart PowerShell |
| Captions out of sync | Audio quality issue — try with a cleaner audio source |
| First run is slow | Whisper downloading AI model (~140MB) — wait once |
