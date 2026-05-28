# ============================================
# SATU CAKRAWALA - Claude Code Team Setup
# ============================================
# Install via PowerShell:
#   irm https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-windows.ps1 | iex
#
# Atau clone & run:
#   .\setup-windows.ps1
# ============================================

$ErrorActionPreference = "Stop"

function Print-Status  { Write-Host "[OK] $args" -ForegroundColor Green }
function Print-Warn    { Write-Host "[!] $args" -ForegroundColor Yellow }
function Print-Error   { Write-Host "[X] $args" -ForegroundColor Red }

# ==========================================
# Animasi helper
# ==========================================
function Show-ProgressBar {
    param([string]$Label, [int]$Duration = 2)

    $width = 30
    $spin = @('⠋','⠙','⠹','⠸','⠼','⠴','⠦','⠧','⠇','⠏')
    $steps = $Duration * 10

    for ($i = 0; $i -le $steps; $i++) {
        $pct = [math]::Floor($i * 100 / $steps)
        $filled = [math]::Floor($i * $width / $steps)
        $empty = $width - $filled
        $bar = ("█" * $filled) + ("░" * $empty)
        $spinChar = $spin[$i % 10]
        Write-Host -NoNewline "`r  $spinChar $Label $bar $pct%"
        Start-Sleep -Milliseconds 100
    }
    $fullBar = "█" * $width
    Write-Host -NoNewline "`r  "
    Write-Host -NoNewline -ForegroundColor Green "✓"
    Write-Host " $Label $fullBar 100%"
}

function Show-TypingText {
    param([string]$Text, [consolecolor]$Color = "Cyan")

    foreach ($char in $Text.ToCharArray()) {
        Write-Host -NoNewline -ForegroundColor $Color $char
        Start-Sleep -Milliseconds 30
    }
    Write-Host ""
}

function Show-RainbowLine {
    param([int]$Width = 71)

    $colors = @("Red","Yellow","Green","Cyan","Blue","Magenta")
    for ($i = 0; $i -lt $Width; $i++) {
        $ci = $i % $colors.Count
        Write-Host -NoNewline -ForegroundColor $colors[$ci] "━"
        Start-Sleep -Milliseconds 10
    }
    Write-Host ""
}

function Show-Confetti {
    $width = [console]::WindowWidth
    if (-not $width) { $width = 80 }
    $chars = @('✦','✧','★','☆','◆','◇','●','○','▲','△','■','□')
    $colors = @("Red","Green","Yellow","Blue","Magenta","Cyan","DarkRed","DarkYellow","DarkBlue","DarkMagenta","DarkCyan")

    for ($row = 0; $row -lt 3; $row++) {
        $line = ""
        for ($i = 0; $i -lt $width; $i++) {
            $ci = Get-Random -Maximum $colors.Count
            $ch = $chars[(Get-Random -Maximum $chars.Count)]
            $line += $ch
        }
        Write-Host -ForegroundColor $colors[(Get-Random -Maximum $colors.Count)] $line.Substring(0, [math]::Min($line.Length, $width))
        Start-Sleep -Milliseconds 150
    }
}

# ==========================================
# SATU CAKRAWALA - Animated Banner
# ==========================================
Write-Host ""

# Baris atas — animasi rainbow
Show-RainbowLine

Write-Host ""

# Tulisan SATU — muncul baris per baris
$SatuBanner = @(
    "               ████    █     █████  █   █  "
    "              █       █ █      █    █   █  "
    "               ████   █████    █    █   █  "
    "                  █   █   █    █    █   █  "
    "               ████   █   █    █     ███   "
)
foreach ($line in $SatuBanner) {
    Write-Host -ForegroundColor Cyan $line
    Start-Sleep -Milliseconds 120
}

Write-Host ""

# Tulisan CAKRAWALA — muncul baris per baris
$CakrawalaBanner = @(
    "     ████   █   █  █ ███    █   █   █   █    █       █     █  "
    "    █      █ █ █ █  █   █ █ █   █  █ █    █ █     █     █ █ "
    "    █      ███████   ███  ██████ █ █ █  █████  █      █████"
    "    █      █   █ █ █  █ █  █   ███ ██  █   █  █      █   █"
    "     ████  █   ██  █ █  █ █   ██   ██   █   █ █████  █   █"
)
foreach ($line in $CakrawalaBanner) {
    Write-Host -ForegroundColor Blue $line
    Start-Sleep -Milliseconds 120
}

Write-Host ""

# Subtitle — typing effect
Write-Host -NoNewline "    "
Show-TypingText "Satu Cakrawala · Claude Code · Team Setup" DarkGray

Write-Host ""

# Baris bawah — animasi rainbow
Show-RainbowLine

Write-Host ""

# Loading animation
Show-ProgressBar "Memulai setup..." 2

# ---------- 1. Cek OS ----------
if (-not $IsWindows -and -not ($env:OS -match "Windows")) {
    Print-Error "Script ini untuk Windows. Untuk macOS/Linux gunakan setup-mac.sh"
    exit 1
}
Print-Status "OS: Windows"

# ---------- 2. Cek & install Node.js ----------
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = node -v
    Print-Status "Node.js sudah terinstall: $nodeVersion"
}
else {
    Print-Warn "Node.js belum terinstall."

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "  Menginstall Node.js via winget..."
        winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
    }
    elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "  Menginstall Node.js via scoop..."
        scoop install nodejs-lts
    }
    else {
        Print-Error "Tidak ditemukan winget atau scoop."
        Write-Host "  Install Node.js manual: https://nodejs.org"
        Write-Host "  Atau install winget dari Microsoft Store."
        exit 1
    }

    $env:PATH = [System.Environment]::GetEnvironmentVariable("Machine","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("User","Machine")

    if (Get-Command node -ErrorAction SilentlyContinue) {
        Print-Status "Node.js berhasil diinstall: $(node -v)"
    }
    else {
        Print-Error "Node.js terinstall tapi tidak ditemukan di PATH."
        Write-Host "  Restart terminal dan jalankan ulang script ini."
        exit 1
    }
}

# ---------- 3. Cek & install Claude Code ----------
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Print-Status "Claude Code sudah terinstall"
}
else {
    Print-Warn "Claude Code belum terinstall. Menginstall via npm..."
    Show-ProgressBar "Installing Claude Code" 3
    npm install -g @anthropic-ai/claude-code
    Print-Status "Claude Code berhasil diinstall"
}

# ---------- 4. Cek config yang sudah ada ----------
$ClaudeHome = Join-Path $env:USERPROFILE ".claude"
$TeamDir = Join-Path $env:USERPROFILE ".claude-team"
$SettingsDest = Join-Path $ClaudeHome "settings.json"
$EnvFile = Join-Path $TeamDir ".env"

if (-not (Test-Path $ClaudeHome)) { New-Item -ItemType Directory -Path $ClaudeHome | Out-Null }
if (-not (Test-Path $TeamDir)) { New-Item -ItemType Directory -Path $TeamDir | Out-Null }

# Default values
$envVars = @{
    "ANTHROPIC_BASE_URL" = "https://api.z.ai/api/anthropic"
    "ANTHROPIC_AUTH_TOKEN" = ""
    "ANTHROPIC_MODEL" = "glm-5.1"
    "ANTHROPIC_SMALL_FAST_MODEL" = "glm-4.5-air"
    "ANTHROPIC_DEFAULT_SONNET_MODEL" = "glm-5.1"
    "ANTHROPIC_DEFAULT_OPUS_MODEL" = "glm-5.1"
    "ANTHROPIC_DEFAULT_HAIKU_MODEL" = "glm-4.5-air"
    "API_TIMEOUT_MS" = "3000000"
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC" = "1"
}

# Parse existing .env kalau ada
if (Test-Path $EnvFile) {
    Print-Status "Config sudah ada di $EnvFile"
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match "^([A-Z_]+)=(.*)$") {
            $envVars[$Matches[1]] = $Matches[2]
        }
    }
}

# ---------- 5. Input API Key dari user ----------
Write-Host ""
Write-Host "  ━━━ API Configuration ━━━" -ForegroundColor Cyan
Write-Host ""

if ($envVars["ANTHROPIC_AUTH_TOKEN"] -and $envVars["ANTHROPIC_AUTH_TOKEN"] -ne "MASUKAN_API_KEY_KAMU_DISINI") {
    $tokenPreview = $envVars["ANTHROPIC_AUTH_TOKEN"]
    if ($tokenPreview.Length -gt 12) {
        $tokenPreview = $tokenPreview.Substring(0,8) + "..." + $tokenPreview.Substring($tokenPreview.Length - 4)
    }
    Print-Status "API Key sudah tersimpan"
    Write-Host "  (Token: $tokenPreview)" -ForegroundColor DarkGray
    Write-Host ""
    $changeToken = Read-Host "  Ingin ganti token? (y/N)"
    if ($changeToken -eq "y" -or $changeToken -eq "Y") {
        $envVars["ANTHROPIC_AUTH_TOKEN"] = ""
    }
}

if (-not $envVars["ANTHROPIC_AUTH_TOKEN"] -or $envVars["ANTHROPIC_AUTH_TOKEN"] -eq "MASUKAN_API_KEY_KAMU_DISINI") {
    Write-Host "  Masukkan API Key dari " -NoNewline
    Write-Host "z.ai" -ForegroundColor White -NoNewline
    Write-Host " kamu:"
    Write-Host "  (Copas token yang dikasih admin, lalu tekan Enter)" -ForegroundColor DarkGray
    Write-Host ""
    $apiKeyInput = Read-Host "  API Key"

    if (-not $apiKeyInput) {
        Print-Error "API Key tidak boleh kosong!"
        exit 1
    }

    $envVars["ANTHROPIC_AUTH_TOKEN"] = $apiKeyInput
    Print-Status "API Key diterima"
}

# ---------- 6. Simpan .env ----------
Show-ProgressBar "Menyimpan config" 1
$envLines = @(
    "# SATU CAKRAWALA - Claude Code Config"
    "ANTHROPIC_BASE_URL=$($envVars['ANTHROPIC_BASE_URL'])"
    "ANTHROPIC_AUTH_TOKEN=$($envVars['ANTHROPIC_AUTH_TOKEN'])"
    "ANTHROPIC_MODEL=$($envVars['ANTHROPIC_MODEL'])"
    "ANTHROPIC_SMALL_FAST_MODEL=$($envVars['ANTHROPIC_SMALL_FAST_MODEL'])"
    "ANTHROPIC_DEFAULT_SONNET_MODEL=$($envVars['ANTHROPIC_DEFAULT_SONNET_MODEL'])"
    "ANTHROPIC_DEFAULT_OPUS_MODEL=$($envVars['ANTHROPIC_DEFAULT_OPUS_MODEL'])"
    "ANTHROPIC_DEFAULT_HAIKU_MODEL=$($envVars['ANTHROPIC_DEFAULT_HAIKU_MODEL'])"
    "API_TIMEOUT_MS=$($envVars['API_TIMEOUT_MS'])"
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1"
)
$envLines | Set-Content $EnvFile -Encoding UTF8
Print-Status "Config disimpan ke $EnvFile"

# ---------- 7. Set environment variables permanen (User level) ----------
$envVarNames = @(
    "ANTHROPIC_BASE_URL",
    "ANTHROPIC_AUTH_TOKEN",
    "API_TIMEOUT_MS",
    "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC"
)

$alreadySet = [System.Environment]::GetEnvironmentVariable("ANTHROPIC_BASE_URL", "User")

if ($alreadySet) {
    Print-Warn "Environment variables sudah ada, mengupdate..."
}

foreach ($varName in $envVarNames) {
    if ($envVars.ContainsKey($varName) -and $envVars[$varName]) {
        [System.Environment]::SetEnvironmentVariable($varName, $envVars[$varName], "User")
        Set-Item -Path "env:$varName" -Value $envVars[$varName]
    }
}
Print-Status "Environment variables disimpan (User level)"

# ---------- 8. Generate settings.json ----------
if (Test-Path $SettingsDest) {
    $backup = Join-Path $ClaudeHome "settings.json.bak"
    Copy-Item $SettingsDest $backup -Force
    Print-Warn "Backup settings lama ke settings.json.bak"
}

Show-ProgressBar "Generating settings" 1
$settingsJson = @"
{
  "permissions": {
    "allow": [
      "Bash(git *)",
      "Bash(npm *)",
      "Bash(npx *)",
      "Bash(node *)",
      "Bash(pnpm *)",
      "Bash(yarn *)",
      "Bash(cat *)",
      "Bash(ls *)",
      "Bash(find *)",
      "Bash(grep *)",
      "Bash(echo *)",
      "Bash(mkdir *)",
      "Bash(cp *)",
      "Bash(mv *)"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(sudo *)",
      "Bash(curl * | bash*)",
      "Bash(wget * | bash*)"
    ]
  },
  "env": {
    "ANTHROPIC_AUTH_TOKEN": "$($envVars['ANTHROPIC_AUTH_TOKEN'])",
    "ANTHROPIC_BASE_URL": "$($envVars['ANTHROPIC_BASE_URL'])",
    "API_TIMEOUT_MS": "$($envVars['API_TIMEOUT_MS'])",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "$($envVars['ANTHROPIC_DEFAULT_HAIKU_MODEL'])",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "$($envVars['ANTHROPIC_DEFAULT_SONNET_MODEL'])",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "$($envVars['ANTHROPIC_DEFAULT_OPUS_MODEL'])"
  }
}
"@
$settingsJson | Set-Content $SettingsDest -Encoding UTF8
Print-Status "Settings digenerate ke $SettingsDest"

# ---------- 9. Selesai ----------
Write-Host ""
Write-Host "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""

# Confetti!
Show-Confetti

Write-Host ""
Write-Host "  🎉 Setup selesai!" -ForegroundColor Green
Write-Host ""
Write-Host "  Langkah selanjutnya:"
Write-Host "    1. Restart PowerShell/terminal"
Write-Host "    2. Masuk ke project:   cd C:\path\to\project"
Write-Host "    3. Jalankan Claude Code:  claude"
Write-Host ""
Write-Host "  Update konfigurasi:"
Write-Host "    Re-run script ini, atau edit manual:"
Write-Host "    Config  ->  $EnvFile"
Write-Host "    Setting ->  $SettingsDest"
Write-Host ""
Write-Host "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host ""
