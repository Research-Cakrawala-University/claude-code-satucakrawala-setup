#!/bin/bash

# ============================================
# SATU CAKRAWALA - Claude Code Team Setup
# ============================================
# Install via curl:
#   curl -fsSL https://raw.githubusercontent.com/Research-Cakrawala-University/claude-code-satucakrawala-setup/main/setup-mac.sh | bash
#
# Atau clone & run:
#   chmod +x setup-mac.sh && ./setup-mac.sh
# ============================================

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

print_status()  { echo -e "${GREEN}[✓]${NC} $1"; }
print_warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
print_error()   { echo -e "${RED}[✗]${NC} $1"; }

# ==========================================
# Animasi helper
# ==========================================
hide_cursor()  { printf "\033[?25l"; }
show_cursor()  { printf "\033[?25h"; }
trap show_cursor EXIT

animate_progress() {
    local label="$1"
    local duration="${2:-2}"
    local width=30
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local steps=$((duration * 10))
    local i

    hide_cursor
    for ((i=0; i<=steps; i++)); do
        local pct=$((i * 100 / steps))
        local filled=$((i * width / steps))
        local empty=$((width - filled))
        local bar=""
        local j
        for ((j=0; j<filled; j++)); do bar+="█"; done
        for ((j=0; j<empty; j++)); do bar+="░"; done
        local spin_char="${spin:$((i % 10)):1}"
        printf "\r  ${spin_char} ${CYAN}${label}${NC} ${bar} ${BOLD}${pct}%%${NC}"
        sleep 0.1
    done
    printf "\r  ${GREEN}✓${NC} ${label} ${GREEN}%s${NC} ${BOLD}100%%${NC}\n" "$(printf '█%.0s' $(seq 1 $width))"
    show_cursor
}

animate_typing() {
    local text="$1"
    local color="${2:-$CYAN}"
    local i
    hide_cursor
    for ((i=0; i<${#text}; i++)); do
        printf "${color}${text:$i:1}${NC}"
        sleep 0.03
    done
    echo ""
    show_cursor
}

animate_rainbow_line() {
    local width="${1:-71}"
    local colors=('\033[0;31m' '\033[0;33m' '\033[0;32m' '\033[0;36m' '\033[0;34m' '\033[0;35m')
    local num_colors=${#colors[@]}
    local i
    hide_cursor
    for ((i=0; i<width; i++)); do
        local ci=$((i % num_colors))
        printf "${colors[$ci]}━${NC}"
        sleep 0.01
    done
    echo ""
    show_cursor
}

animate_countdown() {
    local text="$1"
    local seconds="${2:-3}"
    local i
    hide_cursor
    for ((i=seconds; i>0; i--)); do
        printf "\r  ${BOLD}${MAGENTA}${text} ${i}...${NC}"
        sleep 1
    done
    printf "\r  ${GREEN}${text} GO!          ${NC}\n"
    show_cursor
}

animate_confetti() {
    local width=$(tput cols 2>/dev/null || echo 80)
    local chars='✦✧★☆◆◇●○▲△■□'
    local colors=('\033[0;31m' '\033[0;32m' '\033[0;33m' '\033[0;34m' '\033[0;35m' '\033[0;36m' '\033[1;31m' '\033[1;33m' '\033[1;34m' '\033[1;35m' '\033[1;36m')
    local line
    local row
    hide_cursor
    for ((row=0; row<3; row++)); do
        line=""
        for ((i=0; i<width; i++)); do
            local ci=$((RANDOM % ${#colors[@]}))
            local ch=$(printf '%s' "$chars" | cut -c$((RANDOM % ${#chars} + 1)))
            line+="${colors[$ci]}${ch}${NC}"
        done
        printf "%s\n" "$line"
        sleep 0.15
    done
    show_cursor
}

# ==========================================
# Matrix rain effect (background)
# ==========================================
matrix_rain_frame() {
    local width=$(tput cols 2>/dev/null || echo 80)
    local height=${1:-5}
    local chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#$%&'
    local num_chars=${#chars}
    local row col
    for ((row=0; row<height; row++)); do
        local line=""
        for ((col=0; col<width; col++)); do
            local ci=$((RANDOM % num_chars))
            local ch="${chars:$ci:1}"
            local brightness=$((RANDOM % 3))
            case $brightness in
                0) line+="${DIM}\033[0;32m${ch}${NC}" ;;
                1) line+="${DIM}\033[0;36m${ch}${NC}" ;;
                2) line+="${DIM}\033[2;37m${ch}${NC}" ;;
            esac
        done
        echo -e "$line"
    done
}

# ==========================================
# Decode effect — karakter acak berubah jadi teks asli
# ==========================================
animate_decode_line() {
    local target="$1"
    local color="$2"
    local scramble_chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#&!?*+=/<>[]{}'
    local num_scramble=${#scramble_chars}
    local len=${#target}
    local rounds=12
    local round i

    hide_cursor
    for ((round=0; round<=rounds; round++)); do
        local display=""
        for ((i=0; i<len; i++)); do
            local target_char="${target:$i:1}"
            if [[ "$target_char" == " " ]]; then
                display+=" "
                continue
            fi
            # Semakin banyak round, semakin banyak karakter yang "lock" ke target
            local lock_chance=$((round * 100 / rounds))
            local rand=$((RANDOM % 100))
            if [[ $rand -lt $lock_chance ]]; then
                display+="${target_char}"
            else
                local si=$((RANDOM % num_scramble))
                display+="${scramble_chars:$si:1}"
            fi
        done
        printf "\r  %b%s%b" "$color" "$display" "$NC"
        sleep 0.06
    done
    printf "\r  %b%s%b\n" "$color" "$target" "$NC"
    show_cursor
}

# ==========================================
# Color wave over ASCII art lines
# ==========================================
animate_color_wave() {
    local -a lines=("$@")
    local num_lines=${#lines[@]}
    local colors=(
        '\033[1;36m'  # cyan bright
        '\033[1;34m'  # blue bright
        '\033[1;35m'  # magenta bright
        '\033[1;33m'  # yellow bright
        '\033[1;32m'  # green bright
        '\033[1;36m'  # cyan bright
    )
    local num_colors=${#colors[@]}
    local frames=20
    local frame line_idx

    hide_cursor
    # First: print all lines dim
    tput sc  # save cursor
    for ((line_idx=0; line_idx<num_lines; line_idx++)); do
        printf "  %b%s%b\n" "$DIM" "${lines[$line_idx]}" "$NC"
    done

    # Now animate color wave over them
    for ((frame=0; frame<frames; frame++)); do
        tput rc  # restore cursor
        for ((line_idx=0; line_idx<num_lines; line_idx++)); do
            local line="${lines[$line_idx]}"
            local line_len=${#line}
            local display=""
            local ci_offset=$(( (frame + line_idx) % num_colors ))
            local col
            for ((col=0; col<line_len; col++)); do
                local ch="${line:$col:1}"
                if [[ "$ch" == " " ]]; then
                    display+=" "
                    continue
                fi
                # Wave position based on frame and column
                local wave_pos=$(( (col + frame * 3) % 40 ))
                local dist=${wave_pos}
                if [[ $dist -gt 20 ]]; then
                    dist=$((40 - dist))
                fi
                if [[ $dist -lt 8 ]]; then
                    local ci=$(( (ci_offset + col / 8) % num_colors ))
                    display+="${colors[$ci]}${ch}${NC}"
                else
                    display+="${DIM}${ch}${NC}"
                fi
            done
            printf "  %b\n" "$display"
        done
        sleep 0.08
    done

    # Final: show all bright
    tput rc
    for ((line_idx=0; line_idx<num_lines; line_idx++)); do
        local ci=$((line_idx % num_colors))
        printf "  %b%b%s%b\n" "$BOLD" "${colors[$ci]}" "${lines[$line_idx]}" "$NC"
    done
    show_cursor
}

# ==========================================
# Glitch effect on text
# ==========================================
animate_glitch_text() {
    local text="$1"
    local color="$2"
    local glitch_chars='_/\\|░▒▓█'
    local len=${#text}
    local frames=8
    local frame

    hide_cursor
    for ((frame=0; frame<frames; frame++)); do
        local display=""
        for ((i=0; i<len; i++)); do
            local ch="${text:$i:1}"
            if [[ "$ch" == " " ]]; then
                display+=" "
                continue
            fi
            if [[ $((RANDOM % 3)) -eq 0 ]]; then
                local gi=$((RANDOM % ${#glitch_chars}))
                display+="${RED}${glitch_chars:$gi:1}${NC}"
            else
                display+="${color}${ch}${NC}"
            fi
        done
        printf "\r  %b   " "$display"
        sleep 0.05
    done
    printf "\r  %b%s%b   \n" "$BOLD$color" "$text" "$NC"
    show_cursor
}
# ==========================================
# SATU CAKRAWALA - Animated Banner
# ==========================================
echo ""

# === Phase 1: Matrix rain intro (1 frame) ===
matrix_rain_frame 3
echo ""

# === Phase 2: Rainbow line top ===
animate_rainbow_line

echo ""

# === Phase 3: ASCII art banner dengan color wave ===
# Strip ANSI codes untuk mendapat pure ASCII art
SATU_LINES=(
    "             ████    █     █████  █   █  "
    "            █       █ █      █    █   █  "
    "             ████   █████    █    █   █  "
    "                █   █   █    █    █   █  "
    "             ████   █   █    █     ███   "
)

CAKRAWALA_LINES=(
    "   ████   █   █  █ ███    █   █   █   █    █       █     █  "
    "  █      █ █ █ █  █   █ █ █   █  █ █    █ █     █     █ █ "
    "  █      ███████   ███  ██████ █ █ █  █████  █      █████"
    "  █      █   █ █ █  █ █  █   ███ ██  █   █  █      █   █"
    "   ████  █   ██  █ █  █ █   ██   ██   █   █ █████  █   █"
)

# Animate SATU with color wave
animate_color_wave "${SATU_LINES[@]}"

echo ""

# Animate CAKRAWALA with color wave
animate_color_wave "${CAKRAWALA_LINES[@]}"

show_cursor

echo ""

# === Phase 4: Subtitle with decode + glitch ===
animate_decode_line ">> Satu Cakrawala · Claude Code · Team Setup" "${DIM}\033[0;36m"
sleep 0.2
animate_glitch_text ">> Satu Cakrawala · Claude Code · Team Setup" "${CYAN}"

echo ""

# === Phase 5: Rainbow line bottom ===
animate_rainbow_line

echo ""

# ---------- Loading animation ----------
animate_progress "Memulai setup..." 2

# ---------- 1. Cek OS ----------
if [[ "$OSTYPE" != "darwin"* && "$OSTYPE" != "linux"* ]]; then
    print_error "Script ini untuk macOS/Linux. Untuk Windows gunakan PowerShell command di README."
    exit 1
fi
print_status "OS terdeteksi: $OSTYPE"

# ---------- 2. Cek & install Node.js ----------
check_node() {
    if command -v node &> /dev/null; then
        local version=$(node -v)
        print_status "Node.js sudah terinstall: $version"
    else
        print_warn "Node.js belum terinstall."

        if [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                echo "  Menginstall Node.js via Homebrew..."
                brew install node
            else
                print_error "Homebrew belum terinstall. Install dulu:"
                echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
                exit 1
            fi
        else
            if command -v nvm &> /dev/null; then
                nvm install --lts
            elif command -v curl &> /dev/null; then
                echo "  Menginstall Node.js via NodeSource..."
                curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
                sudo apt-get install -y nodejs
            else
                print_error "Tidak bisa install Node.js otomatis. Install manual: https://nodejs.org"
                exit 1
            fi
        fi

        print_status "Node.js berhasil diinstall: $(node -v)"
    fi
}

check_node

# ---------- 3. Cek & install Claude Code ----------
if command -v claude &> /dev/null; then
    print_status "Claude Code sudah terinstall"
else
    print_warn "Claude Code belum terinstall. Menginstall via npm..."
    animate_progress "Installing Claude Code" 3
    npm install -g @anthropic-ai/claude-code
    print_status "Claude Code berhasil diinstall"
fi

# ---------- 4. Cek config yang sudah ada ----------
CLAUDE_HOME="$HOME/.claude"
CLAUDE_TEAM_DIR="$HOME/.claude-team"
SETTINGS_DEST="$CLAUDE_HOME/settings.json"
ENV_FILE="$CLAUDE_TEAM_DIR/.env"

mkdir -p "$CLAUDE_HOME"
mkdir -p "$CLAUDE_TEAM_DIR"

# Default values
ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic"
ANTHROPIC_MODEL="glm-5.1"
ANTHROPIC_SMALL_FAST_MODEL="glm-4.5-air"
ANTHROPIC_DEFAULT_SONNET_MODEL="glm-5.1"
ANTHROPIC_DEFAULT_OPUS_MODEL="glm-5.1"
ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.5-air"
API_TIMEOUT_MS="3000000"
ANTHROPIC_AUTH_TOKEN=""

# Parse existing .env kalau ada
if [[ -f "$ENV_FILE" ]]; then
    print_status "Config sudah ada di $ENV_FILE"
    while IFS='=' read -r key value; do
        [[ "$key" =~ ^#.*$ ]] && continue
        [[ -z "$key" ]] && continue
        declare "$key=$value"
    done < "$ENV_FILE"
fi

# ---------- 5. Input API Key dari user ----------
echo ""
echo -e "  ${BOLD}${CYAN}━━━ API Configuration ━━━${NC}"
echo ""

if [[ -n "$ANTHROPIC_AUTH_TOKEN" && "$ANTHROPIC_AUTH_TOKEN" != "MASUKAN_API_KEY_KAMU_DISINI" ]]; then
    print_status "API Key sudah tersimpan"
    echo -e "  ${DIM}(Token: ${ANTHROPIC_AUTH_TOKEN:0:8}...${ANTHROPIC_AUTH_TOKEN: -4})${NC}"
    echo ""
    # Saat curl | bash, stdin adalah pipe, jadi baca dari /dev/tty
    read -p "  Ingin ganti token? (y/N): " change_token < /dev/tty
    if [[ "$change_token" =~ ^[Yy]$ ]]; then
        ANTHROPIC_AUTH_TOKEN=""
    fi
fi

if [[ -z "$ANTHROPIC_AUTH_TOKEN" || "$ANTHROPIC_AUTH_TOKEN" == "MASUKAN_API_KEY_KAMU_DISINI" ]]; then
    echo -e "  Masukkan API Key dari ${BOLD}z.ai${NC} kamu:"
    echo -e "  ${DIM}(Copas token yang dikasih admin, lalu tekan Enter)${NC}"
    echo ""
    read -p "  API Key: " api_key_input < /dev/tty

    if [[ -z "$api_key_input" ]]; then
        print_error "API Key tidak boleh kosong!"
        exit 1
    fi

    ANTHROPIC_AUTH_TOKEN="$api_key_input"
    print_status "API Key diterima"
fi

# ---------- 6. Simpan .env ----------
animate_progress "Menyimpan config" 1
cat > "$ENV_FILE" << ENVFILE
# SATU CAKRAWALA - Claude Code Config
ANTHROPIC_BASE_URL=$ANTHROPIC_BASE_URL
ANTHROPIC_AUTH_TOKEN=$ANTHROPIC_AUTH_TOKEN
ANTHROPIC_MODEL=$ANTHROPIC_MODEL
ANTHROPIC_SMALL_FAST_MODEL=$ANTHROPIC_SMALL_FAST_MODEL
ANTHROPIC_DEFAULT_SONNET_MODEL=$ANTHROPIC_DEFAULT_SONNET_MODEL
ANTHROPIC_DEFAULT_OPUS_MODEL=$ANTHROPIC_DEFAULT_OPUS_MODEL
ANTHROPIC_DEFAULT_HAIKU_MODEL=$ANTHROPIC_DEFAULT_HAIKU_MODEL
API_TIMEOUT_MS=$API_TIMEOUT_MS
CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
ENVFILE
print_status "Config disimpan ke $ENV_FILE"

# ---------- 7. Set environment variables permanen ----------
SHELL_RC=""
if [[ -f "$HOME/.zshrc" ]]; then
    SHELL_RC="$HOME/.zshrc"
elif [[ -f "$HOME/.bashrc" ]]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [[ -n "$SHELL_RC" ]]; then
    if grep -q "CLAUDE_TEAM_SETUP_MARKER" "$SHELL_RC" 2>/dev/null; then
        # Update existing block
        print_warn "Environment variables sudah ada, mengupdate..."
        # Remove old block
        sed -i.bak '/# CLAUDE_TEAM_SETUP_MARKER/,/^# END_CLAUDE_TEAM_SETUP/d' "$SHELL_RC"
        rm -f "$SHELL_RC.bak"
    fi
    echo "" >> "$SHELL_RC"
    echo "# CLAUDE_TEAM_SETUP_MARKER" >> "$SHELL_RC"
    echo "# Satu Cakrawala - Claude Code Team Config (auto-added)" >> "$SHELL_RC"
    echo "export ANTHROPIC_BASE_URL=\"$ANTHROPIC_BASE_URL\"" >> "$SHELL_RC"
    echo "export ANTHROPIC_AUTH_TOKEN=\"$ANTHROPIC_AUTH_TOKEN\"" >> "$SHELL_RC"
    echo "export API_TIMEOUT_MS=\"$API_TIMEOUT_MS\"" >> "$SHELL_RC"
    echo "export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1" >> "$SHELL_RC"
    echo "# END_CLAUDE_TEAM_SETUP" >> "$SHELL_RC"
    print_status "Environment variables ditambahkan ke $SHELL_RC"
else
    print_warn "Tidak ditemukan .zshrc atau .bashrc. Set env vars manual."
fi

# ---------- 8. Generate ~/.claude/settings.json ----------
if [[ -f "$SETTINGS_DEST" ]]; then
    BACKUP="$SETTINGS_DEST.bak"
    cp "$SETTINGS_DEST" "$BACKUP"
    print_warn "Backup settings lama ke $BACKUP"
fi

animate_progress "Generating settings" 1
cat > "$SETTINGS_DEST" << SETTINGSJSON
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
    "ANTHROPIC_AUTH_TOKEN": "$ANTHROPIC_AUTH_TOKEN",
    "ANTHROPIC_BASE_URL": "$ANTHROPIC_BASE_URL",
    "API_TIMEOUT_MS": "$API_TIMEOUT_MS",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "$ANTHROPIC_DEFAULT_HAIKU_MODEL",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "$ANTHROPIC_DEFAULT_SONNET_MODEL",
    "ANTHROPIC_DEFAULT_OPUS_MODEL": "$ANTHROPIC_DEFAULT_OPUS_MODEL"
  }
}
SETTINGSJSON
print_status "Settings digenerate ke $SETTINGS_DEST"

# ---------- 9. Selesai ----------
echo ""
echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Confetti!
animate_confetti

echo ""
echo -e "  ${BOLD}${GREEN}  🎉 Setup selesai!${NC}"
echo ""
echo -e "  ${BOLD}Langkah selanjutnya:${NC}"
echo "    1. Restart terminal (biar env vars ke-load)"
echo "    2. Masuk ke project kamu:  cd /path/to/project"
echo "    3. Jalankan Claude Code:   claude"
echo ""
echo "  Update konfigurasi:"
echo "    Re-run script ini, atau edit manual:"
echo -e "    Config  ${CYAN}→${NC}  $ENV_FILE"
echo -e "    Setting ${CYAN}→${NC}  $SETTINGS_DEST"
echo ""
echo -e "  ${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
