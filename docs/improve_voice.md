# 🎙️ Voice Improver

> Enhance, clean, and master your recorded voice tracks using professional filters for equalization, compression, and loudness normalization.

**Script:** `scripts/improve_voice.ps1`

---

## ✅ Requirements

| Requirement | How to install |
|-------------|----------------|
| ffmpeg | `winget install Gyan.FFmpeg` |

---

## 🚀 How to Use

**Step 1 — Right-click the script → Run with PowerShell**
```
📁 Open: scripts\
📄 Right-click: improve_voice.ps1
▶️ Click: Run with PowerShell
```

**Step 2 — Enter your video or audio path**
```
File path:
```
Right-click your media file → **Copy as path** → paste → press Enter

**Step 3 — Pick a Voice Profile**
```
[1] Balanced Clear Vocal (Recommended)
    - Cleans hiss, balances loudness, boosts speech clarity
[2] Podcast / Deep Voice
    - Adds warm radio/podcast-like depth to vocals
[3] Extreme Noise Cleanup
    - Extra strong denoiser for heavy wind/AC/outdoor noise
```

---

## 📁 Output

Saved in the **same folder as your input file** with the `_enhanced` label added:

* Input: `myvideo.mp4`
* Output: `myvideo_enhanced.mp4`

---

## 🎛️ What the Script Does

* **Rumble Removal**: High-pass filtering cuts out low-end microphone hums and vibrations below 85Hz.
* **Intelligent Noise Reduction**: The `afftdn` (FFT Denoiser) filter reduces static room sounds like fans, AC, and background computer hums.
* **Presence EQ**: Boosts mid-to-high voice frequencies (2kHz - 4kHz) to make speech highly intelligible and clear.
* **Vocal Warmth EQ (Podcast Profile)**: Boosts chest resonance frequencies (150Hz) for a radio/podcast body feeling.
* **Dynamic Range Compression**: Levels out the volume spikes so that soft whispers and loud laughter are normalized to a consistent, comfortable listening volume.
* **Loudness Normalization**: Targets standard YouTube/Web loudness (`-16 LUFS`) to make your video's audio match professional standards.
