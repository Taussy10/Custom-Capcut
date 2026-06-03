# 🎙️ Remotion JSON Timings & Frames Generator

This tool uses Python and Whisper AI to transcribe audio files (like `.mp3`, `.wav`, etc.) and automatically generate:
- **Remotion-ready JSON** with word-level start/end times and calculated frames.

---

## ⚡ How to Run

1. Open the `scripts/` folder.
2. Right-click [generate_audio_captions.ps1](file:///E:/Tausif/Custom-Capcut/scripts/generate_audio_captions.ps1) and choose **Run with PowerShell**.
3. Drag & drop or paste the path to your audio file.
4. Enter your target **FPS** for the Remotion project (e.g., `30` or `60`, default is `30`).
5. Choose the Whisper model size:
   - `tiny`: Fastest, lowest accuracy.
   - `base` (Default): Good balance of speed and accuracy.
   - `small`: Higher accuracy, slightly slower.
   - `medium`: Very high accuracy, slowest.
6. The script will generate the Remotion JSON file in the same folder as your input audio:
   - `<audio_name>_remotion.json` (Word-level timestamps with calculated frames for Remotion animation)

---

## 📁 Output JSON Format Example

```json
{
  "audio_file": "bangladesh_narration.mp3",
  "fps": 30,
  "words": [
    { "word": "This",        "start": 0.00, "end": 0.18, "frame_start": 0,  "frame_end": 5  },
    { "word": "is",          "start": 0.18, "end": 0.28, "frame_start": 5,  "frame_end": 8  },
    { "word": "Bangladesh",  "start": 0.28, "end": 0.85, "frame_start": 8,  "frame_end": 25 }
  ]
}
```

---

## 🛠️ Requirements

- **Python 3.11+** installed and added to your system PATH.
- **openai-whisper**: Installed via `pip install openai-whisper`.
