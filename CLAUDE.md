# SATU CAKRAWALA - Claude Code Team Setup

## One-Liner Install

### macOS / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-mac.sh | bash
```

### Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-windows.ps1 | iex
```

## Yang Perlu Disiapkan

- API Key dari z.ai (akan diminta saat setup berjalan)

## Setelah Setup

1. Restart terminal
2. Jalankan Claude Code:
```bash
cd /path/to/project
claude
```

## Update Konfigurasi

Re-run command install yang sama, atau edit manual:
- Config: `~/.claude-team/.env`
- Settings: `~/.claude/settings.json`
