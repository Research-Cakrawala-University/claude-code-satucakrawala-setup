# PANDUAN INSTALL CLAUDE CODE
## Tim Satu Cakrawala — Research Cakrawala University

---

## Apa itu Claude Code?

Claude Code adalah AI coding assistant dari Anthropic yang bisa langsung dipakai di terminal. Kita menggunakan dua pilihan provider: **z.ai (GLM)** atau **Mimo (Xiomi)** sebagai backend.

Dengan setup ini, semua member tim bisa langsung pakai Claude Code tanpa configurasi manual — cukup jalankan satu command, pilih provider, masukkan API key, selesai.

---

## Yang Perlu Disiapkan

Sebelum mulai, pastikan kamu punya:

| Kebutuhan | Keterangan |
|---|---|
| **API Key** | Minta dari admin tim (sesuai provider yang dipilih) |
| **Koneksi internet** | Untuk download Node.js, Claude Code, dan hubungkan ke API |
| **Terminal / PowerShell** | Untuk menjalankan command install |

---

## Provider yang Tersedia

| Provider | URL | Model | Fast Model |
|---|---|---|---|
| **z.ai (GLM)** | `https://api.z.ai/api/anthropic` | glm-5.1 | glm-4.5-air |
| **Mimo (Xiomi)** | `https://token-plan-sgp.xiaomimimo.com/anthropic` | mimo-v2.5-pro | mimo-v2.5 |

> Pilih salah satu. Admin akan kasih API key sesuai provider yang kamu pilih.

### Model Mapping

| Claude Code Setting | z.ai (GLM) | Mimo (Xiomi) |
|---|---|---|
| Default Model | glm-5.1 | mimo-v2.5-pro |
| Small/Fast Model | glm-4.5-air | mimo-v2.5 |
| Sonnet Model | glm-5.1 | mimo-v2.5 |
| Opus Model | glm-5.1 | mimo-v2.5-pro |
| Haiku Model | glm-4.5-air | mimo-v2.5 |

---

## BAGIAN 1: Install Node.js

Node.js wajib terinstall sebelum menjalankan script Claude Code.

### Langkah 1.1: Cek Apakah Node.js Sudah Terinstall

Buka terminal dan jalankan:

```bash
node -v
```

**Kalau muncul versi seperti `v20.x.x` atau `v22.x.x`** → Node.js sudah terinstall, langsung lanjut ke **Bagian 2**.

**Kalau muncul `command not found: node`** → Node.js belum terinstall, lanjut ke Langkah 1.2.

---

### Langkah 1.2: Install Node.js

Pilih sesuai sistem operasi kamu:

#### macOS (via Homebrew)

**a) Cek apakah Homebrew sudah ada:**

```bash
brew -v
```

**b) Kalau `command not found: brew`**, install Homebrew dulu:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Tunggu sampai selesai. Ikuti instruksi yang muncul di terminal kalau ada.

**c) Install Node.js via Homebrew:**

```bash
brew install node
```

**d) Verifikasi:**

```bash
node -v
npm -v
```

Harus muncul versi Node.js dan npm. Lanjut ke **Bagian 2**.

---

#### Linux (Ubuntu / Debian)

**a) Update package list:**

```bash
sudo apt update
```

**b) Install Node.js via NodeSource (versi LTS):**

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

**c) Verifikasi:**

```bash
node -v
npm -v
```

Harus muncul versi Node.js dan npm. Lanjut ke **Bagian 2**.

---

#### Windows

Ada 2 cara, pilih salah satu:

##### Cara 1: Download Installer (Paling Mudah)

1. Buka browser, kunjungi **https://nodejs.org**
2. Klik tombol **LTS** (Recommended for Most Users) untuk download
3. Jalankan file `.msi` yang terdownload
4. Klik **Next** terus sampai **Install**, lalu **Finish**
5. Restart PowerShell / terminal
6. Verifikasi:

```powershell
node -v
npm -v
```

##### Cara 2: via winget (Windows Package Manager)

1. Buka **PowerShell**
2. Jalankan:

```powershell
winget install OpenJS.NodeJS.LTS
```

3. Restart PowerShell
4. Verifikasi:

```powershell
node -v
npm -v
```

---

### Langkah 1.3: Troubleshooting Node.js

| Masalah | Solusi |
|---|---|
| `command not found: node` setelah install di Windows | Restart terminal / PowerShell |
| `command not found: node` setelah install di macOS | Jalankan `brew doctor` lalu ikuti instruksi, atau restart terminal |
| `node -v` muncul versi di bawah v18 | Update Node.js ke versi LTS terbaru |

> Pastikan Node.js versi **v18 atau lebih baru** sebelum lanjut ke Bagian 2.

---

## BAGIAN 2: Install Claude Code

Setelah Node.js terinstall, sekarang jalankan script setup Claude Code.

### Langkah 2.1: Buka Terminal

- **macOS**: Buka app **Terminal** (Command + Space, ketik "Terminal")
- **Linux**: Buka **Terminal** (Ctrl + Alt + T)
- **Windows**: Buka **PowerShell** (Start, ketik "PowerShell")

### Langkah 2.2: Jalankan Command Install

Copy salah satu command di bawah, paste di terminal, lalu tekan Enter.

> **Penting:** Pastikan command dalam satu baris utuh, jangan sampai kepotong.

**macOS / Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-mac.sh | bash
```

**Windows (PowerShell):**

```powershell
irm https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-windows.ps1 | iex
```

> **Tips paste di terminal:**
> - **macOS**: Cmd + V
> - **Linux**: Ctrl + Shift + V
> - **Windows**: Klik kanan

### Langkah 2.3: Pilih Provider

Saat muncul menu pilihan provider:

```
  ━━━ Pilih Provider ━━━

    1. z.ai (GLM)
       URL: https://api.z.ai/api/anthropic
       Model: glm-5.1

    2. Mimo (Xiomi)
       URL: https://token-plan-sgp.xiaomimimo.com/anthropic
       Model: mimo-v2.5-pro

  Pilih (1/2):
```

Ketik **1** untuk z.ai atau **2** untuk Mimo, lalu tekan Enter.

> Pilih provider sesuai API key yang dikasih admin.

### Langkah 2.4: Tunggu Proses Otomatis

Script akan otomatis:

1. Cek apakah **Claude Code** sudah terinstall. Kalau belum, akan install via npm
2. Muncul prompt untuk memasukkan **API Key**

Tunggu sampai muncul prompt API key. Biasanya sebentar kalau koneksi internet stabil.

### Langkah 2.5: Masukkan API Key

Saat muncul prompt seperti ini:

```
  ━━━ API Configuration ━━━

  Masukkan API Key dari provider kamu:
  (Copas token yang dikasih admin, lalu tekan Enter)

  API Key:
```

1. Minta token API Key dari admin tim
2. Copy token tersebut
3. Paste di terminal
4. Tekan **Enter**

> **Tips:** Klik kanan di terminal untuk paste, atau gunakan Ctrl+Shift+V (Linux) / Cmd+V (macOS)

### Langkah 2.6: Tunggu Sampai Selesai

Kalau muncul pesan seperti ini:

```
  [✓] Config disimpan ke ~/.claude-team/.env
  [✓] Environment variables ditambahkan ke ~/.zshrc
  [✓] Settings digenerate ke ~/.claude/settings.json

  🎉 Setup selesai!

    Langkah selanjutnya:
      1. Restart terminal (biar env vars ke-load)
      2. Masuk ke project kamu:  cd /path/to/project
      3. Jalankan Claude Code:   claude
```

Berarti install berhasil! Lanjut ke **Bagian 3**.

---

## BAGIAN 3: Mulai Menggunakan Claude Code

### Langkah 3.1: Restart Terminal

**Tutup terminal**, lalu buka lagi. Ini penting supaya environment variables ke-load.

### Langkah 3.2: Masuk ke Folder Project

```bash
cd /path/to/project-kamu
```

Ganti `/path/to/project-kamu` dengan lokasi folder project kamu.

Contoh:

```bash
cd ~/Documents/my-project
cd ~/projects/frontend-app
cd C:\Users\NamaKamu\projects\web-app
```

### Langkah 3.3: Jalankan Claude Code

```bash
claude
```

Claude Code akan mulai dan siap menerima perintah.

---

## BAGIAN 4: Cara Pakai Claude Code

Setelah menjalankan `claude`, kamu bisa langsung mengetik perintah dalam bahasa Indonesia atau Inggris.

### Contoh Perintah

| Perintah | Fungsi |
|---|---|
| `bantu buatkan komponen button` | Minta Claude buat komponen |
| `fix bug di file auth.ts` | Minta Claude perbaiki bug |
| `jelaskan fungsi ini` | Minta Claude jelaskan kode |
| `buat unit test untuk file utils.js` | Minta Claude buat test |
| `refactor kode ini` | Minta Claude perbaiki struktur kode |
| `/help` | Lihat bantuan Claude Code |

### Tips Pakai Claude Code

- Tulis perintah yang jelas dan spesifik
- Claude Code bisa baca, edit, dan buat file di project kamu
- Claude Code bisa jalankan command terminal (dengan permission)
- Kalau Claude Code nanya konfirmasi, baca dulu lalu jawab y/n

---

## BAGIAN 5: Update & Maintenance

### Ganti Provider

Jalankan ulang command install. Script akan detect provider sekarang dan tanya:

```
  [✓] Provider sekarang: z.ai

  Ganti provider? (y/N):
```

Ketik **y** untuk ganti provider, lalu pilih provider baru.

> **Catatan:** Kalau ganti provider, kamu juga perlu masukkan API key baru dari provider tersebut.

### Update API Key

Jalankan ulang command install:

**macOS / Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-mac.sh | bash
```

**Windows:**

```powershell
irm https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-windows.ps1 | iex
```

Saat ditanya "Ingin ganti token?", ketik **y** lalu Enter. Masukkan API key baru.

### Update Claude Code ke Versi Terbaru

```bash
npm install -g @anthropic-ai/claude-code
```

---

## BAGIAN 6: Troubleshooting

### `command not found: claude`

**Penyebab:** Claude Code belum terinstall atau tidak ada di PATH.

**Solusi:**

```bash
npm install -g @anthropic-ai/claude-code
```

---

### `command not found: node`

**Penyebab:** Node.js belum terinstall.

**Solusi:** Kembali ke **Bagian 1** dan install Node.js sesuai sistem operasi kamu.

---

### API connection error

**Penyebab:** API key salah, expired, atau koneksi ke server bermasalah.

**Solusi:**
1. Jalankan ulang script install untuk update token
2. Pastikan API key masih valid
3. Cek koneksi internet
4. Untuk z.ai: cek apakah bisa akses `https://api.z.ai`
5. Untuk Mimo: cek apakah bisa akses `https://token-plan-sgp.xiaomimimo.com`

---

### Windows: Script tidak bisa dijalankan

**Penyebab:** Execution policy memblokir script PowerShell.

**Solusi:**

Buka PowerShell **as Administrator**, lalu jalankan:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

Lalu jalankan ulang command install.

---

### `Permission denied` (macOS/Linux)

**Penyebab:** Script tidak punya execute permission (kalau dijalankan lokal via clone).

**Solusi:**

```bash
chmod +x setup-mac.sh
./setup-mac.sh
```

Atau gunakan cara `curl | bash` yang otomatis tanpa perlu chmod.

---

### Command kepotong saat di-paste

**Penyebab:** URL panjang dan ter-wrap ke baris baru saat copy-paste.

**Solusi:**
- Pastikan command dalam **satu baris utuh**
- Jangan ada spasi atau enter di tengah URL
- Atau ketik manual: `curl -fsSL <URL> | bash`

---

## BAGIAN 7: File Config yang Dihasilkan

Script akan membuat file-file berikut:

| File | Lokasi | Isi |
|---|---|---|
| Team Config | `~/.claude-team/.env` | API key, URL, model, timeout, provider |
| Claude Settings | `~/.claude/settings.json` | Permissions + env vars |
| Shell Config | `~/.zshrc` / `~/.bashrc` | Environment variables permanen |

> **Penting:** Jangan share file `.env` karena berisi API key kamu.

---

## BAGIAN 8: Uninstall

Kalau mau menghapus Claude Code dan semua config-nya:

**macOS / Linux:**

```bash
# Hapus Claude Code
npm uninstall -g @anthropic-ai/claude-code

# Hapus config
rm -rf ~/.claude-team
rm ~/.claude/settings.json

# Hapus env vars dari shell config
# Buka ~/.zshrc atau ~/.bashrc
# Hapus blok dari # CLAUDE_TEAM_SETUP_MARKER sampai # END_CLAUDE_TEAM_SETUP
```

**Windows (PowerShell):**

```powershell
# Hapus Claude Code
npm uninstall -g @anthropic-ai/claude-code

# Hapus config
Remove-Item -Recurse -Force "$env:USERPROFILE\.claude-team"
Remove-Item -Force "$env:USERPROFILE\.claude\settings.json"

# Hapus npm-global
Remove-Item -Recurse -Force "$env:USERPROFILE\.npm-global" -ErrorAction SilentlyContinue

# Hapus env vars
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_BASE_URL", $null, "User")
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_AUTH_TOKEN", $null, "User")
[System.Environment]::SetEnvironmentVariable("API_TIMEOUT_MS", $null, "User")
[System.Environment]::SetEnvironmentVariable("CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC", $null, "User")

# Hapus npm-global dari PATH
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
$newPath = ($currentPath -split ";" | Where-Object { $_ -notlike "*\.npm-global*" }) -join ";"
[System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
```

---

## System Requirements

| Platform | Minimum |
|---|---|
| **Node.js** | v18+ |
| **macOS** | 12+ (Monterey) |
| **Linux** | Ubuntu 20.04+ / equivalent |
| **Windows** | 10+ dengan PowerShell 5+ |

---

## Butuh Bantuan?

Hubungi admin tim Satu Cakrawala atau open issue di:

https://github.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/issues

---

*Satu Cakrawala — Research Cakrawala University*
