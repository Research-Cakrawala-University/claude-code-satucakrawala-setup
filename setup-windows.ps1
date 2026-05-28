# ============================================
# SATU CAKRAWALA - Claude Code Team Setup
# ============================================

$ErrorActionPreference = 'Stop'

function Print-Status  { Write-Host '[OK]' $args -ForegroundColor Green }
function Print-Warn    { Write-Host '[!]' $args -ForegroundColor Yellow }
function Print-Error   { Write-Host '[X]' $args -ForegroundColor Red }

# ==========================================
# Cek Unicode support
# ==========================================
$unicodeOk = $false
try {
    [console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8
    $unicodeOk = $true
} catch {}

# ==========================================
# Animasi helper
# ==========================================
function Show-ProgressBar {
    param([string]$Label, [int]$Duration = 2)

    $w = 30
    if ($unicodeOk) {
        $spinCh = @([char]0x280B,[char]0x2819,[char]0x2839,[char]0x2838,[char]0x283C,[char]0x2834,[char]0x2826,[char]0x2827,[char]0x2807,[char]0x280F)
        $fc = [string][char]0x2588
        $ec = [string][char]0x2591
    } else {
        $spinCh = @('|','/','-','\','|','/','-','\','|','/')
        $fc = '#'
        $ec = '-'
    }
    $steps = $Duration * 10

    for ($i = 0; $i -le $steps; $i++) {
        $pct = [math]::Floor($i * 100 / $steps)
        $filled = [math]::Floor($i * $w / $steps)
        $empty = $w - $filled
        $bar = ($fc * $filled) + ($ec * $empty)
        $sc = $spinCh[$i % 10]
        Write-Host -NoNewline ("`r  {0} {1} {2} {3}%" -f $sc,$Label,$bar,$pct)
        Start-Sleep -Milliseconds 100
    }
    $fullBar = $fc * $w
    Write-Host -NoNewline "`r  "
    Write-Host -NoNewline -ForegroundColor Green 'OK'
    Write-Host " $Label $fullBar 100%"
}

function Show-TypingText {
    param([string]$Text, [consolecolor]$Color = 'Cyan')
    foreach ($c in $Text.ToCharArray()) {
        Write-Host -NoNewline -ForegroundColor $Color $c
        Start-Sleep -Milliseconds 30
    }
    Write-Host ''
}

function Show-RainbowLine {
    param([int]$Width = 71)
    $colors = @('Red','Yellow','Green','Cyan','Blue','Magenta')
    $ch = if ($unicodeOk) { [string][char]0x2501 } else { '=' }
    for ($i = 0; $i -lt $Width; $i++) {
        Write-Host -NoNewline -ForegroundColor $colors[$i % 6] $ch
        Start-Sleep -Milliseconds 10
    }
    Write-Host ''
}

function Show-Confetti {
    $w = 60
    if ($unicodeOk) {
        $chars = @('*','#','@','+','o','O','x','X','$','%','&','^')
    } else {
        $chars = @('*','#','@','+','o','O','x','X','$','%','&','^')
    }
    $colors = @('Red','Green','Yellow','Blue','Magenta','Cyan','DarkRed','DarkYellow','DarkBlue','DarkMagenta','DarkCyan')

    for ($row = 0; $row -lt 3; $row++) {
        $line = ''
        for ($i = 0; $i -lt $w; $i++) {
            $line += $chars[(Get-Random -Maximum $chars.Count)]
        }
        Write-Host -ForegroundColor $colors[(Get-Random -Maximum $colors.Count)] $line
        Start-Sleep -Milliseconds 150
    }
}

# ==========================================
# SATU CAKRAWALA - Animated Banner
# ==========================================
Write-Host ''
Show-RainbowLine
Write-Host ''

$SatuBanner = @(
    '               ████    █     █████  █   █  '
    '              █       █ █      █    █   █  '
    '               ████   █████    █    █   █  '
    '                  █   █   █    █    █   █  '
    '               ████   █   █    █     ███   '
)
foreach ($line in $SatuBanner) {
    Write-Host -ForegroundColor Cyan $line
    Start-Sleep -Milliseconds 120
}

Write-Host ''

$CakrawalaBanner = @(
    '     ████   █   █  █ ███    █   █   █   █    █       █     █  '
    '    █      █ █ █ █  █   █ █ █   █  █ █    █ █     █     █ █ '
    '    █      ███████   ███  ██████ █ █ █  █████  █      █████'
    '    █      █   █ █ █  █ █  █   ███ ██  █   █  █      █   █'
    '     ████  █   ██  █ █  █ █   ██   ██   █   █ █████  █   █'
)
foreach ($line in $CakrawalaBanner) {
    Write-Host -ForegroundColor Blue $line
    Start-Sleep -Milliseconds 120
}

Write-Host ''
Write-Host -NoNewline '    '
Show-TypingText 'Satu Cakrawala - Claude Code - Team Setup' DarkGray
Write-Host ''
Show-RainbowLine
Write-Host ''

Show-ProgressBar 'Memulai setup...' 2

# ---------- 1. Cek OS ----------
$isWin = $false
if ($env:OS -match 'Windows') { $isWin = $true }
if ($IsWindows) { $isWin = $true }
if (-not $isWin) {
    Print-Error 'Script ini untuk Windows. Untuk macOS/Linux gunakan setup-mac.sh'
    exit 1
}
Print-Status 'OS: Windows'

# ---------- 2. Cek & install Node.js ----------
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = node -v
    Print-Status "Node.js sudah terinstall: $nodeVersion"
}
else {
    Print-Warn 'Node.js belum terinstall.'

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host '  Menginstall Node.js via winget...'
        winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
    }
    elseif (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host '  Menginstall Node.js via scoop...'
        scoop install nodejs-lts
    }
    else {
        Print-Error 'Tidak ditemukan winget atau scoop.'
        Write-Host '  Install Node.js manual: https://nodejs.org'
        Write-Host '  Atau install winget dari Microsoft Store.'
        exit 1
    }

    $env:PATH = [System.Environment]::GetEnvironmentVariable('Machine','Machine') + ';' + [System.Environment]::GetEnvironmentVariable('User','Machine')

    if (Get-Command node -ErrorAction SilentlyContinue) {
        Print-Status "Node.js berhasil diinstall: $(node -v)"
    }
    else {
        Print-Error 'Node.js terinstall tapi tidak ditemukan di PATH.'
        Write-Host '  Restart terminal dan jalankan ulang script ini.'
        exit 1
    }
}

# ---------- 3. Cek & install Claude Code ----------
if (Get-Command claude -ErrorAction SilentlyContinue) {
    Print-Status 'Claude Code sudah terinstall'
}
else {
    Print-Warn 'Claude Code belum terinstall. Menginstall via npm...'
    Show-ProgressBar 'Installing Claude Code' 3
    npm install -g @anthropic-ai/claude-code
    Print-Status 'Claude Code berhasil diinstall'
}

# ---------- 4. Cek config yang sudah ada ----------
$ClaudeHome = Join-Path $env:USERPROFILE '.claude'
$TeamDir = Join-Path $env:USERPROFILE '.claude-team'
$SettingsDest = Join-Path $ClaudeHome 'settings.json'
$EnvFile = Join-Path $TeamDir '.env'

if (-not (Test-Path $ClaudeHome)) { New-Item -ItemType Directory -Path $ClaudeHome | Out-Null }
if (-not (Test-Path $TeamDir)) { New-Item -ItemType Directory -Path $TeamDir | Out-Null }

$envVars = @{
    'ANTHROPIC_BASE_URL' = ''
    'ANTHROPIC_AUTH_TOKEN' = ''
    'ANTHROPIC_MODEL' = ''
    'ANTHROPIC_SMALL_FAST_MODEL' = ''
    'ANTHROPIC_DEFAULT_SONNET_MODEL' = ''
    'ANTHROPIC_DEFAULT_OPUS_MODEL' = ''
    'ANTHROPIC_DEFAULT_HAIKU_MODEL' = ''
    'API_TIMEOUT_MS' = '3000000'
    'CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC' = '1'
    'PROVIDER_NAME' = ''
}

if (Test-Path $EnvFile) {
    Print-Status "Config sudah ada di $EnvFile"
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match '^([A-Z_]+)=(.*)$') {
            $envVars[$Matches[1]] = $Matches[2]
        }
    }
}

# Detect provider dari URL yang sudah tersimpan
$currentUrl = $envVars['ANTHROPIC_BASE_URL']
$detectedProvider = ''
if ($currentUrl -match 'z\.ai') {
    $detectedProvider = 'z.ai'
} elseif ($currentUrl -match 'xiaomimimo') {
    $detectedProvider = 'mimo'
}

# ---------- 5. Pilih Provider ----------
Write-Host ''
Write-Host '  --- Pilih Provider ---' -ForegroundColor Cyan
Write-Host ''
Write-Host '    1. z.ai (GLM)' -ForegroundColor White
Write-Host '       URL: https://api.z.ai/api/anthropic' -ForegroundColor DarkGray
Write-Host '       Model: glm-5.1' -ForegroundColor DarkGray
Write-Host ''
Write-Host '    2. Mimo (Xiomi)' -ForegroundColor White
Write-Host '       URL: https://token-plan-sgp.xiaomimimo.com/anthropic' -ForegroundColor DarkGray
Write-Host '       Model: mimo-v2.5-pro' -ForegroundColor DarkGray
Write-Host ''

$skipProviderSelect = $false
if ($detectedProvider) {
    Print-Status "Provider sekarang: $detectedProvider"
    Write-Host ''
    $changeProvider = Read-Host '  Ganti provider? (y/N)'
    if ($changeProvider -ne 'y' -and $changeProvider -ne 'Y') {
        $skipProviderSelect = $true
        Print-Status "Mempertahankan provider: $detectedProvider"
    }
}

if (-not $skipProviderSelect) {
    $providerChoice = Read-Host '  Pilih (1/2)'
    Write-Host ''

    if ($providerChoice -eq '1') {
        $envVars['PROVIDER_NAME'] = 'z.ai'
        $envVars['ANTHROPIC_BASE_URL'] = 'https://api.z.ai/api/anthropic'
        $envVars['ANTHROPIC_MODEL'] = 'glm-5.1'
        $envVars['ANTHROPIC_SMALL_FAST_MODEL'] = 'glm-4.5-air'
        $envVars['ANTHROPIC_DEFAULT_SONNET_MODEL'] = 'glm-5.1'
        $envVars['ANTHROPIC_DEFAULT_OPUS_MODEL'] = 'glm-5.1'
        $envVars['ANTHROPIC_DEFAULT_HAIKU_MODEL'] = 'glm-4.5-air'
    }
    elseif ($providerChoice -eq '2') {
        $envVars['PROVIDER_NAME'] = 'mimo'
        $envVars['ANTHROPIC_BASE_URL'] = 'https://token-plan-sgp.xiaomimimo.com/anthropic'
        $envVars['ANTHROPIC_MODEL'] = 'mimo-v2.5-pro'
        $envVars['ANTHROPIC_SMALL_FAST_MODEL'] = 'mimo-v2.5'
        $envVars['ANTHROPIC_DEFAULT_SONNET_MODEL'] = 'mimo-v2.5'
        $envVars['ANTHROPIC_DEFAULT_OPUS_MODEL'] = 'mimo-v2.5-pro'
        $envVars['ANTHROPIC_DEFAULT_HAIKU_MODEL'] = 'mimo-v2.5'
    }
    else {
        Print-Error 'Pilihan tidak valid!'
        exit 1
    }
    Print-Status "Provider dipilih: $($envVars['PROVIDER_NAME'])"
}

$providerName = $envVars['PROVIDER_NAME']

# ---------- 6. Input API Key ----------
Write-Host ''
Write-Host '  --- API Configuration ---' -ForegroundColor Cyan
Write-Host ''

$existingToken = $envVars['ANTHROPIC_AUTH_TOKEN']
if ($existingToken -and $existingToken -ne 'MASUKAN_API_KEY_KAMU_DISINI') {
    $tokenPreview = $existingToken
    if ($tokenPreview.Length -gt 12) {
        $tokenPreview = $tokenPreview.Substring(0,8) + '...' + $tokenPreview.Substring($tokenPreview.Length - 4)
    }
    Print-Status 'API Key sudah tersimpan'
    Write-Host "  (Token: $tokenPreview)" -ForegroundColor DarkGray
    Write-Host ''
    $changeToken = Read-Host '  Ingin ganti token? (y/N)'
    if ($changeToken -eq 'y' -or $changeToken -eq 'Y') {
        $envVars['ANTHROPIC_AUTH_TOKEN'] = ''
    }
}

$currentToken = $envVars['ANTHROPIC_AUTH_TOKEN']
if (-not $currentToken -or $currentToken -eq 'MASUKAN_API_KEY_KAMU_DISINI') {
    Write-Host "  Masukkan API Key dari $providerName kamu:"
    Write-Host '  (Copas token yang dikasih admin, lalu tekan Enter)' -ForegroundColor DarkGray
    Write-Host ''
    $apiKeyInput = Read-Host '  API Key'

    if (-not $apiKeyInput) {
        Print-Error 'API Key tidak boleh kosong!'
        exit 1
    }

    $envVars['ANTHROPIC_AUTH_TOKEN'] = $apiKeyInput
    Print-Status 'API Key diterima'
}

# ---------- 7. Simpan .env ----------
Show-ProgressBar 'Menyimpan config' 1
$envLines = @(
    '# SATU CAKRAWALA - Claude Code Config'
    "ANTHROPIC_BASE_URL=$($envVars['ANTHROPIC_BASE_URL'])"
    "ANTHROPIC_AUTH_TOKEN=$($envVars['ANTHROPIC_AUTH_TOKEN'])"
    "ANTHROPIC_MODEL=$($envVars['ANTHROPIC_MODEL'])"
    "ANTHROPIC_SMALL_FAST_MODEL=$($envVars['ANTHROPIC_SMALL_FAST_MODEL'])"
    "ANTHROPIC_DEFAULT_SONNET_MODEL=$($envVars['ANTHROPIC_DEFAULT_SONNET_MODEL'])"
    "ANTHROPIC_DEFAULT_OPUS_MODEL=$($envVars['ANTHROPIC_DEFAULT_OPUS_MODEL'])"
    "ANTHROPIC_DEFAULT_HAIKU_MODEL=$($envVars['ANTHROPIC_DEFAULT_HAIKU_MODEL'])"
    "API_TIMEOUT_MS=$($envVars['API_TIMEOUT_MS'])"
    'CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1'
    "PROVIDER_NAME=$($envVars['PROVIDER_NAME'])"
)
$envLines | Set-Content $EnvFile -Encoding UTF8
Print-Status "Config disimpan ke $EnvFile"

# ---------- 8. Set environment variables permanen (User level) ----------
$envVarNames = @(
    'ANTHROPIC_BASE_URL'
    'ANTHROPIC_AUTH_TOKEN'
    'API_TIMEOUT_MS'
    'CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC'
)

$alreadySet = [System.Environment]::GetEnvironmentVariable('ANTHROPIC_BASE_URL', 'User')

if ($alreadySet) {
    Print-Warn 'Environment variables sudah ada, mengupdate...'
}

foreach ($varName in $envVarNames) {
    if ($envVars.ContainsKey($varName) -and $envVars[$varName]) {
        [System.Environment]::SetEnvironmentVariable($varName, $envVars[$varName], 'User')
        Set-Item -Path "env:$varName" -Value $envVars[$varName]
    }
}
Print-Status 'Environment variables disimpan (User level)'

# ---------- 9. Generate settings.json ----------
if (Test-Path $SettingsDest) {
    $backup = Join-Path $ClaudeHome 'settings.json.bak'
    Copy-Item $SettingsDest $backup -Force
    Print-Warn 'Backup settings lama ke settings.json.bak'
}

Show-ProgressBar 'Generating settings' 1

$tok = $envVars['ANTHROPIC_AUTH_TOKEN']
$url = $envVars['ANTHROPIC_BASE_URL']
$tmo = $envVars['API_TIMEOUT_MS']
$hk = $envVars['ANTHROPIC_DEFAULT_HAIKU_MODEL']
$sn = $envVars['ANTHROPIC_DEFAULT_SONNET_MODEL']
$op = $envVars['ANTHROPIC_DEFAULT_OPUS_MODEL']

$settingsJson = "{`n"
$settingsJson += '  "permissions": {' + "`n"
$settingsJson += '    "allow": [' + "`n"
$settingsJson += '      "Bash(git *)",' + "`n"
$settingsJson += '      "Bash(npm *)",' + "`n"
$settingsJson += '      "Bash(npx *)",' + "`n"
$settingsJson += '      "Bash(node *)",' + "`n"
$settingsJson += '      "Bash(pnpm *)",' + "`n"
$settingsJson += '      "Bash(yarn *)",' + "`n"
$settingsJson += '      "Bash(cat *)",' + "`n"
$settingsJson += '      "Bash(ls *)",' + "`n"
$settingsJson += '      "Bash(find *)",' + "`n"
$settingsJson += '      "Bash(grep *)",' + "`n"
$settingsJson += '      "Bash(echo *)",' + "`n"
$settingsJson += '      "Bash(mkdir *)",' + "`n"
$settingsJson += '      "Bash(cp *)",' + "`n"
$settingsJson += '      "Bash(mv *)"' + "`n"
$settingsJson += '    ],' + "`n"
$settingsJson += '    "deny": [' + "`n"
$settingsJson += '      "Bash(rm -rf *)",' + "`n"
$settingsJson += '      "Bash(sudo *)",' + "`n"
$settingsJson += '      "Bash(curl * | bash*)",' + "`n"
$settingsJson += '      "Bash(wget * | bash*)"' + "`n"
$settingsJson += '    ]' + "`n"
$settingsJson += '  },' + "`n"
$settingsJson += '  "env": {' + "`n"
$settingsJson += "    `"ANTHROPIC_AUTH_TOKEN`": `"$tok`"," + "`n"
$settingsJson += "    `"ANTHROPIC_BASE_URL`": `"$url`"," + "`n"
$settingsJson += "    `"API_TIMEOUT_MS`": `"$tmo`"," + "`n"
$settingsJson += "    `"ANTHROPIC_DEFAULT_HAIKU_MODEL`": `"$hk`"," + "`n"
$settingsJson += "    `"ANTHROPIC_DEFAULT_SONNET_MODEL`": `"$sn`"," + "`n"
$settingsJson += "    `"ANTHROPIC_DEFAULT_OPUS_MODEL`": `"$op`"" + "`n"
$settingsJson += '  }' + "`n"
$settingsJson += '}' + "`n"

$settingsJson | Set-Content $SettingsDest -Encoding UTF8
Print-Status "Settings digenerate ke $SettingsDest"

# ---------- 10. Selesai ----------
Write-Host ''
Write-Host '  ================================================================' -ForegroundColor Cyan
Write-Host ''

Show-Confetti

Write-Host ''
Write-Host '  Setup selesai!' -ForegroundColor Green
Write-Host ''
Write-Host '  Langkah selanjutnya:'
Write-Host '    1. Restart PowerShell/terminal'
Write-Host '    2. Masuk ke project:   cd C:\path\to\project'
Write-Host '    3. Jalankan Claude Code:  claude'
Write-Host ''
Write-Host '  Update konfigurasi:'
Write-Host '    Re-run script ini, atau edit manual:'
Write-Host "    Config  ->  $EnvFile"
Write-Host "    Setting ->  $SettingsDest"
Write-Host ''
Write-Host '  ================================================================' -ForegroundColor Cyan
Write-Host ''
