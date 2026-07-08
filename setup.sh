#!/bin/bash

# macOS Setup Script
# Installs Homebrew, apps, CLI tools, fonts, and copies dotfiles

set -u

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error()   { echo -e "${RED}✗${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
    log_info "Dry run mode — nothing will be installed"
fi

if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only."
    exit 1
fi

if [[ $(uname -m) != "arm64" ]]; then
    log_warning "This script is optimized for Apple Silicon. You're running on $(uname -m)."
fi

log_info "Starting macOS setup..."

# ============================================================================
# Xcode Command Line Tools
# ============================================================================
log_info "Checking for Xcode Command Line Tools..."

if ! xcode-select -p &> /dev/null; then
    log_warning "Xcode Command Line Tools not found."
    xcode-select --install
    log_info "Please complete the installation, then run this script again."
    exit 0
else
    log_success "Xcode Command Line Tools are installed"
fi

# ============================================================================
# Homebrew
# ============================================================================
log_info "Checking for Homebrew..."

if ! command -v brew &> /dev/null; then
    if $DRY_RUN; then
        log_warning "WOULD install Homebrew"
    else
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        log_success "Homebrew installed"
    fi
else
    log_success "Homebrew is already installed"
fi

if ! $DRY_RUN; then
    log_info "Updating Homebrew..."
    brew update
fi

# ============================================================================
# Homebrew Taps
# ============================================================================
log_info "Adding Homebrew taps..."
if ! $DRY_RUN; then
    brew tap zackbart/tap 2>/dev/null || true
    brew tap stripe/stripe-cli 2>/dev/null || true
    brew tap supabase/tap 2>/dev/null || true
    brew tap anomalyco/tap 2>/dev/null || true
    brew tap homebrew-ffmpeg/ffmpeg 2>/dev/null || true
    brew tap pluk-inc/tap 2>/dev/null || true
    brew tap cameroncooke/axe 2>/dev/null || true
    brew tap getsentry/xcodebuildmcp 2>/dev/null || true
    brew tap nubjs/tap 2>/dev/null || true
fi

# ============================================================================
# GUI Applications (Homebrew Casks)
# ============================================================================
log_info "Installing GUI applications..."

CASK_APPS=(
    # Browsers
    "google-chrome"

    # Development
    "android-commandlinetools"
    "docker-desktop"
    "gcloud-cli"
    "ghostty"
    "lm-studio"
    "t3-code"

    # AI & Productivity
    "claude"
    "fluidvoice"
    "granola"
    "notion"
    "notion-calendar"
    "obsidian"
    "raycast"

    # Design
    "figma"

    # Markdown
    "markdown-preview"

    # Utilities
    "appcleaner"
    "balenaetcher"
    "clop"
    "loadout"
    "localsend"
    "openusage"
    "puremac"
    "rustdesk"
    "stillcolor"
    "wifiman"
    "windo"

    # Media
    "anki"
    "handbrake-app"
    "obs"
    "spotify"
    "vlc"

    # Networking
    "mitmproxy"
    "mullvad-vpn"
    "ngrok"
    "tailscale-app"
    "twingate"
    "vb-cable"

    # Communication
    "discord"
    "zoom"

    # Database
    "tablepro"

    # Virtualization
    "utm"

    # CLI tools distributed as casks
    "codex"
    "cursor-cli"
)

INSTALLED_CASKS=$(brew list --cask 2>/dev/null)

for app in "${CASK_APPS[@]}"; do
    if grep -qx "$app" <<< "$INSTALLED_CASKS"; then
        log_success "$app is already installed"
    elif $DRY_RUN; then
        log_warning "WOULD install cask: $app"
    else
        log_info "Installing $app..."
        if brew install --cask "$app" 2>&1; then
            log_success "$app installed"
        else
            log_warning "Failed to install $app"
        fi
    fi
done

log_success "GUI applications complete"

# ============================================================================
# Mac App Store Apps (via mas)
# ============================================================================
log_info "Installing Mac App Store apps..."

if ! command -v mas &> /dev/null; then
    if $DRY_RUN; then
        log_warning "WOULD install mas (Mac App Store CLI)"
    else
        brew install mas
    fi
fi

# Format: "id:name"
MAS_APPS=(
    "937984704:Amphetamine"
    "1452453066:Hidden Bar"
    "1451685025:WireGuard"
    "899247664:TestFlight"
    "497799835:Xcode"
    "640199958:Apple Developer"
    "1494023538:Plash"
    "425264550:Blackmagic Disk Speed Test"
    "409183694:Keynote"
    "409203825:Numbers"
    "409201541:Pages"
)

INSTALLED_MAS=$(mas list 2>/dev/null)

for entry in "${MAS_APPS[@]}"; do
    id="${entry%%:*}"
    name="${entry##*:}"
    if grep -qE "^[[:space:]]*${id}[[:space:]]" <<< "$INSTALLED_MAS"; then
        log_success "$name is already installed"
    elif $DRY_RUN; then
        log_warning "WOULD install from App Store: $name ($id)"
    else
        log_info "Installing $name..."
        if mas install "$id" 2>&1; then
            log_success "$name installed"
        else
            log_warning "Failed to install $name (are you signed into the App Store?)"
        fi
    fi
done

log_success "App Store apps complete"

# ============================================================================
# Fonts
# ============================================================================
log_info "Installing fonts..."

FONTS=(
    "font-jetbrains-mono"
    "font-jetbrains-mono-nerd-font"
    "font-symbols-only-nerd-font"
)

for font in "${FONTS[@]}"; do
    if grep -qx "$font" <<< "$INSTALLED_CASKS"; then
        log_success "$font is already installed"
    elif $DRY_RUN; then
        log_warning "WOULD install font: $font"
    else
        log_info "Installing $font..."
        brew install --cask "$font" 2>&1 && log_success "$font installed" || log_warning "Failed to install $font"
    fi
done

# ============================================================================
# CLI Tools (Homebrew Formulae)
# ============================================================================
log_info "Installing CLI tools..."

CLI_TOOLS=(
    # Shell & prompt
    "starship"
    "zoxide"
    "fzf"
    "tmux"

    # Modern coreutils replacements
    "bat"
    "eza"
    "fd"
    "ripgrep"
    "difftastic"

    # Git
    "gh"
    "lazygit"

    # System monitoring
    "bottom"

    # Docker
    "lazydocker"

    # Languages & runtimes
    "node"                # system Node (nub provisions pinned versions per-project)
    "nubjs/tap/nub"       # all-in-one JS toolkit: installs, scripts, dlx, globals, versions
    "go"
    "openjdk@17"
    "uv"                  # Python: interpreters, venvs, and tools all via uv

    # Data
    "jq"
    "duckdb"

    # Media processing
    "homebrew-ffmpeg/ffmpeg/ffmpeg"  # custom build with extra codecs
    "imagemagick"
    "handbrake"               # CLI; handbrake-app cask is the GUI

    # Documents
    "pandoc"

    # Cloud & deploy
    "supabase"
    "stripe"
    "railway"
    "firebase-cli"

    # Security
    "gnupg"

    # Database client
    "libpq"

    # Utilities
    "cloc"
    "dust"
    "mole"
    "herdr"
    "sevenzip"
    "summarize"
    "mas"
    "agent-browser"

    # AI coding agents
    "anomalyco/tap/opencode"

    # Apple / iOS dev
    "xcodegen"
    "libimobiledevice"
    "molten-vk"
    "cocoapods"
    "cameroncooke/axe/axe"
    "getsentry/xcodebuildmcp/xcodebuildmcp"

    # Google Workspace
    "googleworkspace-cli"

    # Tap tools (zackbart)
    "zackbart/tap/cleenup"
    "zackbart/tap/dbseer"
    "zackbart/tap/seer"
)

INSTALLED_FORMULAE=$(brew list --formula 2>/dev/null)

for tool in "${CLI_TOOLS[@]}"; do
    if grep -qx "${tool##*/}" <<< "$INSTALLED_FORMULAE"; then
        log_success "$tool is already installed"
    elif $DRY_RUN; then
        log_warning "WOULD install formula: $tool"
    else
        log_info "Installing $tool..."
        if brew install "$tool" 2>&1; then
            log_success "$tool installed"
        else
            log_warning "Failed to install $tool"
        fi
    fi
done

log_success "CLI tools complete"

# ============================================================================
# Global JS CLIs (via nub)
# ============================================================================
log_info "Installing global JS CLIs with nub..."

NUB_GLOBALS=(
    "skills"
    "vercel"
    "wrangler"
)

for pkg in "${NUB_GLOBALS[@]}"; do
    if command -v "$pkg" &> /dev/null || [ -x "$HOME/Library/pnpm/$pkg" ]; then
        log_success "$pkg is already installed"
    elif $DRY_RUN; then
        log_warning "WOULD install global CLI: $pkg"
    else
        log_info "Installing $pkg..."
        if nub add -g "$pkg" 2>&1; then
            log_success "$pkg installed"
        else
            log_warning "Failed to install $pkg"
        fi
    fi
done

log_success "global JS CLIs complete"

# ============================================================================
# External installers (not Homebrew)
# ============================================================================
log_info "Installing external tools..."

# Rust toolchain via rustup
if command -v rustup &> /dev/null || [ -x "$HOME/.cargo/bin/rustup" ]; then
    log_success "rustup is already installed"
elif $DRY_RUN; then
    log_warning "WOULD install rustup"
else
    log_info "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -fsSL https://sh.rustup.rs | sh -s -- -y
    log_success "rustup installed"
fi

# Claude Code (native installer)
if command -v claude &> /dev/null || [ -x "$HOME/.local/bin/claude" ]; then
    log_success "Claude Code is already installed"
elif $DRY_RUN; then
    log_warning "WOULD install Claude Code"
else
    log_info "Installing Claude Code..."
    curl -fsSL https://claude.ai/install.sh | bash
    log_success "Claude Code installed"
fi

# ============================================================================
# Dotfiles
# ============================================================================
log_info "Copying dotfiles..."

copy_dotfile() {
    local src="$1"
    local dest="$2"

    if [ ! -f "$src" ]; then
        log_warning "Source not found: $src"
        return
    fi

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -f "$dest" ] && ! cmp -s "$src" "$dest"; then
        mv "$dest" "${dest}.bak"
        log_warning "Backed up existing $dest to ${dest}.bak"
    fi

    cp "$src" "$dest"
    log_success "Copied $dest"
}

if $DRY_RUN; then
    log_warning "WOULD copy dotfiles/.zshrc -> ~/.zshrc"
    log_warning "WOULD copy dotfiles/.gitconfig -> ~/.gitconfig"
    log_warning "WOULD copy dotfiles/starship.toml -> ~/.config/starship.toml"
    log_warning "WOULD copy dotfiles/ghostty/config -> ~/.config/ghostty/config"
else
    copy_dotfile "$SCRIPT_DIR/dotfiles/.zshrc"          "$HOME/.zshrc"
    copy_dotfile "$SCRIPT_DIR/dotfiles/.gitconfig"      "$HOME/.gitconfig"
    copy_dotfile "$SCRIPT_DIR/dotfiles/starship.toml"   "$HOME/.config/starship.toml"
    copy_dotfile "$SCRIPT_DIR/dotfiles/ghostty/config"  "$HOME/.config/ghostty/config"
fi

# ============================================================================
# Claude Code Skills & Plugins
# ============================================================================
log_info "Claude Code skills, plugins, and claude-hud statusline:"
log_info "  - Follow claude/SETUP.md in this repo (agent-followable)"
log_info "  - Skills record:  https://github.com/zackbart/skills"
log_info "  - Plugins:        https://github.com/zackbart/agent-plugins"

# ============================================================================
# Post-installation
# ============================================================================
if ! $DRY_RUN; then
    log_info "Cleaning up Homebrew..."
    brew cleanup
fi

echo ""
log_success "Setup complete!"
log_info "Restart your terminal or run 'source ~/.zshrc' to apply shell config."
echo ""
log_warning "Manual installs needed:"
log_warning "  - DaVinci Resolve:      https://www.blackmagicdesign.com/products/davinciresolve"
log_warning "  - Send to Kindle:       https://www.amazon.com/sendtokindle (brew cask disabled upstream)"
log_warning "  - GatherV2:             direct download"
log_warning "  - Paper:                direct download"
log_warning "  - Supaste:              direct download"
log_warning ""
log_warning "Post-install:"
log_warning "  - nub global bins live in ~/Library/pnpm (already on PATH via .zshrc)"
