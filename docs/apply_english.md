# 🌐 Apply English UI Translation

> Switches JianyingPro's interface from Chinese to English by replacing the translation file.

**Script:** `scripts/APPLY_ENGLISH.ps1`

---

## ✅ Requirements

- JianyingPro installed at `E:\Tausif\Softwares\JianyingPro`
- If installed elsewhere, edit `$JIANYING_PATH` inside the script

---

## 🚀 How to Use

**Step 1 — Right-click → Run with PowerShell**
```
📁 Open: scripts\
📄 Right-click: APPLY_ENGLISH.ps1
▶️ Click: Run with PowerShell
```

**Step 2 — Done!**  
Launch JianyingPro — the UI will now be in English.

---

## ⚙️ Custom Install Path

If JianyingPro is installed somewhere else, open the script and change this line:

```powershell
$JIANYING_PATH = "E:\Tausif\Softwares\JianyingPro"   # <-- Change this
```

---

## 🔒 Safety

- A **backup** of your original Chinese file is created automatically before applying
- Backup is saved as `zh-Hans.po.bak` in the same folder
- To undo — use `REVERT_TO_CHINESE.ps1`

---

## ⚠️ Troubleshooting

| Problem | Fix |
|---------|-----|
| `ERROR: JianyingPro not found` | Edit `$JIANYING_PATH` in the script to your actual install path |
| UI still in Chinese after applying | Fully close and reopen JianyingPro |
| Covers version `5.5.0.11332` only | May not work on other versions |
