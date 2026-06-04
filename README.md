# SATU CAKRAWALA — Claude Code Team Setup

Setup otomatis untuk tim **Satu Cakrawala** agar bisa langsung pakai **Claude Code** dengan pilihan provider **z.ai (GLM)** atau **Mimo (Xiomi)**.

Tidak perlu clone, tidak perlu configurasi manual — cukup satu command, pilih provider, masukkan API key, selesai.

---

## Installation

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-mac.sh | bash
```

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-windows.ps1 | iex
```

Script akan otomatis:

1. Cek & install **Node.js** (jika belum ada)
2. Cek & install **Claude Code** (jika belum ada)
3. Minta **API Key** dari admin, pilih provider (z.ai atau Mimo), lalu masukkan token
4. Generate `~/.claude/settings.json`
5. Set environment variables permanen

---

## Setelah Install

```bash
# 1. Restart terminal (biar env vars ke-load)
# 2. Masuk ke project kamu
cd /path/to/project-kamu

# 3. Jalankan Claude Code
claude
```

---

## Upgrade

Jalankan ulang command install yang sama:

### macOS / Linux
```bash
curl -fsSL https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-mac.sh | bash
```

### Windows
```powershell
irm https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-windows.ps1 | iex
```

Script akan mendeteksi config yang sudah ada dan bertanya apakah mau update token.

---

## Update API Key

Jalankan ulang script install. Saat ditanya "Ingin ganti token?", jawab **y** dan masukkan API key baru.

Atau edit manual:

| Yang mau diubah | Lokasi |
|---|---|
| API Key / URL | `~/.claude-team/.env` |
| Permissions | `~/.claude/settings.json` |

---

## Uninstall

```bash
# Hapus Claude Code
npm uninstall -g @anthropic-ai/claude-code

# Hapus config (macOS/Linux)
rm -rf ~/.claude-team
rm ~/.claude/settings.json

# Hapus env vars dari shell config
# Buka ~/.zshrc atau ~/.bashrc, hapus blok antara:
#   # CLAUDE_TEAM_SETUP_MARKER
#   ...sampai...
#   # END_CLAUDE_TEAM_SETUP
```

```powershell
# Hapus config (Windows)
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude-team"
Remove-Item -Force "$env:USERPROFILE\.claude\settings.json"

# Hapus env vars (PowerShell)
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $null, "User")
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $null, "User")
[System.Environment]::SetEnvironmentVariable("API_TIMEOUT_MS", $null, "User")
[System.Environment]::SetEnvironmentVariable("CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC", $null, "User")
```

---

## File Locations

| File | Lokasi | Fungsi |
|---|---|---|
| Team Config | `~/.claude-team/.env` | API key, URL, model settings |
| Claude Settings | `~/.claude/settings.json` | Permissions + env vars untuk Claude Code |
| Shell Config | `~/.zshrc` / `~/.bashrc` | Environment variables permanen |

---

## Troubleshooting

### `command not found: claude`

Claude Code belum terinstall atau tidak di PATH:

```bash
npm install -g @anthropic-ai/claude-code
```

### `command not found: node`

Node.js belum terinstall:

- **macOS**: `brew install node`
- **Linux**: `sudo apt install nodejs` atau install dari https://nodejs.org
- **Windows**: Install dari https://nodejs.org

### API connection error

- Jalankan ulang script install untuk update token
- Cek koneksi internet ke provider yang dipilih
- Pastikan API key masih valid
- Untuk z.ai: cek `https://api.z.ai`
- Untuk Mimo: cek `https://token-plan-sgp.xiaomimimo.com`

### `Permission denied` (macOS/Linux)

```bash
# Pastikan script punya execute permission kalau di-run lokal
chmod +x setup-mac.sh
./setup-mac.sh
```

### Windows: script tidak bisa dijalankan

```powershell
# Jalankan PowerShell as Administrator, lalu:
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

# Lalu jalankan ulang script
irm https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-windows.ps1 | iex
```

---

## Requirements

| Requirement | Minimum Version |
|---|---|
| **Node.js** | v18+ (akan di-install otomatis) |
| **macOS** | 12+ (Monterey) |
| **Linux** | Ubuntu 20.04+ / equivalent |
| **Windows** | 10+ dengan PowerShell 5+ |

---

## Clone & Run (Alternatif)

Kalau prefer clone repo:

```bash
git clone https://github.com/Research-Cakrawala-University/claude-code-satucakrawala-setup.git
cd claude-code-satucakrawala-setup
chmod +x setup-mac.sh
./setup-mac.sh
```

```powershell
git clone https://github.com/Research-Cakrawala-University/claude-code-satucakrawala-setup.git
cd claude-code-satucakrawala-setup
.\setup-windows.ps1
```

---

## Lisensi

MIT — Satu Cakrawala Research Team
