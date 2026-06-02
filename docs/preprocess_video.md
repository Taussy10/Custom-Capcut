# 🎬 Video Pre-Processor

> Pre-process any video before importing into your editor — remove silence, reduce noise, compress, crop for Reels, change speed, or trim clips.

**Script:** `scripts/preprocess_video.ps1`

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
📄 Right-click: preprocess_video.ps1
▶️ Click: Run with PowerShell
```

**Step 2 — Enter your video path**
```
Video path:
```
Right-click your video → **Copy as path** → paste → press Enter

**Step 3 — Pick an operation**
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

> You can combine options with a comma: e.g. `1,2` or `1,6`

---

## 📁 Output

Saved in the **same folder as your video** with a label added:

| Operation | Output filename |
|-----------|-----------------|
| Silence Remove | `myvideo_nosilence.mp4` |
| Noise Reduce | `myvideo_clean.mp4` |
| Compress | `myvideo_compressed.mp4` |
| Speed 2x | `myvideo_2x.mp4` |
| Speed 0.5x | `myvideo_slowmo.mp4` |
| Reels Crop | `myvideo_reels.mp4` |
| Trim | `myvideo_trimmed.mp4` |
| All-in-one | `myvideo_nosilence_clean_compressed.mp4` |

---

## 🎛️ What Each Operation Does

| Operation | Before | After |
|-----------|--------|-------|
| Silence Remove | Awkward pauses in video | Auto-cut — video flows tightly |
| Noise Reduce | Background fan/AC hiss | Clean audio |
| Compress | Large file (slow upload) | Smaller file, faster upload |
| Speed 2x | Normal speed | Double speed |
| Speed 0.5x | Normal speed | Smooth slow motion |
| Reels Crop | Horizontal (16:9) | Vertical (9:16) for Shorts/Reels |
| Trim | Full video | Specific clip extracted |

---

## 💡 Tips

- Always process **before** importing into your editor
- Use `All-in-one (8)` for the cleanest result before editing
- Combine `6` + `1` for a Reels-ready clip with no silence
