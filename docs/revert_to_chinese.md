# 🔄 Revert to Chinese UI

> Undoes the English translation and restores JianyingPro's original Chinese interface.

**Script:** `scripts/REVERT_TO_CHINESE.ps1`

---

## 🚀 How to Use

**Step 1 — Right-click → Run with PowerShell**
```
📁 Open: scripts\
📄 Right-click: REVERT_TO_CHINESE.ps1
▶️ Click: Run with PowerShell
```

**Step 2 — Done!**  
Launch JianyingPro — the UI will be back in Chinese.

---

## ℹ️ How it Works

The apply script creates a backup file (`zh-Hans.po.bak`) before making any changes. This revert script simply restores that backup.

> If you never ran `APPLY_ENGLISH.ps1` first, this script will show an error — that's normal.

---

## ⚠️ Troubleshooting

| Problem | Fix |
|---------|-----|
| `ERROR: Backup file not found` | You haven't applied the English translation yet — nothing to revert |
| UI still in English | Fully close and reopen JianyingPro |
