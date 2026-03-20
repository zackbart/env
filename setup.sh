#!/bin/bash

# macOS Setup Script
# Installs Homebrew, apps, CLI tools, fonts, and links dotfiles

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
    brew tap homebrew/cask-fonts 2>/dev/null || true
    brew tap steipete/tap 2>/dev/null || true
    brew tap zackbart/tap 2>/dev/null || true
    brew tap yakitrak/yakitrak 2>/dev/null || true
    brew tap jetbrains/utils 2>/dev/null || true
    brew tap stripe/stripe-cli 2>/dev/null || true
    brew tap supabase/tap 2>/dev/null || true
fi

# ============================================================================
# GUI Applications (Homebrew Casks)
# ============================================================================
log_info "Installing GUI applications..."

CASK_APPS=(
    # Browsers
    "google-chrome"

    # Development
    "cursor"
    "docker-desktop"
    "ghostty"
    "lm-studio"

    # Productivity
    "obsidian"
    "granola"
    "claude"
    "paper"
    "superset"

    # Utilities
    "appcleaner"
    "clop"
    "handy"
    "localsend"
    "cyberduck"
    "balenaetcher"
    "rustdesk"
    "wifiman"
    "send-to-kindle"

    # Media production
    "ndi-tools"

    # Media
    "handbrake-app"
    "obs"
    "spotify"
    "vlc"

    # Networking
    "tailscale-app"
    "termius"
    "twingate"
    "ngrok"

    # Communication
    "zoom"

    # Database
    "beekeeper-studio"

    # Virtualization
    "utm"

    # CLI tools distributed as casks
    "claude-code"
    "codex"
    "gcloud-cli"
)

for app in "${CASK_APPS[@]}"; do
    if brew list --cask "$app" &> /dev/null 2>&1; then
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
)

for entry in "${MAS_APPS[@]}"; do
    id="${entry%%:*}"
    name="${entry##*:}"
    if mas list | grep -q "^$id "; then
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
    if brew list --cask "$font" &> /dev/null 2>&1; then
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

    # Modern coreutils replacements
    "bat"
    "eza"
    "fd"
    "ripgrep"

    # Git
    "gh"
    "lazygit"

    # File manager
    "yazi"

    # System monitoring
    "bottom"

    # Docker
    "lazydocker"

    # Languages & runtimes
    "node"
    "pnpm"
    "go"
    "openjdk"

    # Data
    "jq"
    "duckdb"

    # Media processing
    "ffmpeg"
    "imagemagick"

    # Documents
    "pandoc"
    "poppler"

    # Cloud & deploy
    "supabase"
    "stripe"
    "railway"

    # Security
    "trufflehog"
    "gnupg"

    # Images & rendering
    "chafa"
    "resvg"

    # Database client
    "libpq"

    # Utilities
    "cloc"
    "sevenzip"
    "opencode"

    # Tap tools (steipete)
    "steipete/tap/summarize"

    # Tap tools (zackbart)
    "zackbart/tap/cleenup"
    "zackbart/tap/seer"
    "zackbart/tap/werk"

    # Tap tools (other)
    "yakitrak/yakitrak/obsidian-cli"
    "jetbrains/utils/kotlin-lsp"
)

for tool in "${CLI_TOOLS[@]}"; do
    if brew list "$tool" &> /dev/null 2>&1; then
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
# Global npm Packages
# ============================================================================
log_info "Installing global npm packages..."

NPM_PACKAGES=(
    "@dbml/cli"
    "@googleworkspace/cli"
    "agent-browser"
    "defuddle"
    "pyright"
    "skills"
    "slopmeter"
    "typescript"
    "typescript-language-server"
)

for pkg in "${NPM_PACKAGES[@]}"; do
    if npm list -g "$pkg" &> /dev/null 2>&1; then
        log_success "$pkg is already installed"
    elif $DRY_RUN; then
        log_warning "WOULD install npm package: $pkg"
    else
        log_info "Installing $pkg..."
        if npm install -g "$pkg" 2>&1; then
            log_success "$pkg installed"
        else
            log_warning "Failed to install $pkg"
        fi
    fi
done

log_success "npm packages complete"

# ============================================================================
# Dotfiles
# ============================================================================
log_info "Linking dotfiles..."

link_dotfile() {
    local src="$1"
    local dest="$2"

    if [ ! -f "$src" ]; then
        log_warning "Source not found: $src"
        return
    fi

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -f "$dest" ]; then
        mv "$dest" "${dest}.bak"
        log_warning "Backed up existing $dest to ${dest}.bak"
    fi

    ln -s "$src" "$dest"
    log_success "Linked $dest"
}

if $DRY_RUN; then
    log_warning "WOULD link dotfiles/.zshrc -> ~/.zshrc"
    log_warning "WOULD link dotfiles/.gitconfig -> ~/.gitconfig"
    log_warning "WOULD link dotfiles/starship.toml -> ~/.config/starship.toml"
    log_warning "WOULD link dotfiles/ghostty/config -> ~/.config/ghostty/config"
else
    link_dotfile "$SCRIPT_DIR/dotfiles/.zshrc"          "$HOME/.zshrc"
    link_dotfile "$SCRIPT_DIR/dotfiles/.gitconfig"      "$HOME/.gitconfig"
    link_dotfile "$SCRIPT_DIR/dotfiles/starship.toml"   "$HOME/.config/starship.toml"
    link_dotfile "$SCRIPT_DIR/dotfiles/ghostty/config"  "$HOME/.config/ghostty/config"
fi

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
log_warning "  - DaVinci Resolve:  https://www.blackmagicdesign.com/products/davinciresolve"
log_warning "  - Xcode:            Install from the App Store (or already installed via mas)"
log_warning "  - Notchi:           https://lo.cafe/notchi"
log_warning "  - Readout:          https://readout.app"
log_warning "  - OpenPencil:       https://github.com/open-pencil/open-pencil"
log_warning "  - OpenUsage:        https://github.com/robinebers/openusage"
log_warning "  - FnMacAssistant:   https://github.com/isacucho/FnMacAssistant"
log_warning "  - OpenOats:         https://github.com/yazinsai/OpenOats"
log_warning "  - Clearly:          https://github.com/Shpigford/clearly"
