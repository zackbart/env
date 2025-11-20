#!/bin/bash

# macOS Setup Script for M5 Mac
# This script installs Homebrew, version managers, and essential apps/tools

set -u  # Exit on undefined variable
# Note: We don't use set -e so the script continues if individual apps fail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    log_error "This script is designed for macOS only."
    exit 1
fi

# Check if running on Apple Silicon
if [[ $(uname -m) != "arm64" ]]; then
    log_warning "This script is optimized for Apple Silicon (M5). You're running on $(uname -m)."
fi

log_info "Starting macOS setup for M5 Mac..."

# ============================================================================
# Xcode Command Line Tools Check
# ============================================================================
log_info "Checking for Xcode Command Line Tools..."

if ! xcode-select -p &> /dev/null; then
    log_warning "Xcode Command Line Tools not found."
    log_info "Installing Xcode Command Line Tools (this may take a while)..."
    xcode-select --install
    log_info "Please complete the Xcode Command Line Tools installation, then run this script again."
    exit 0
else
    log_success "Xcode Command Line Tools are installed"
fi

# ============================================================================
# Homebrew Installation
# ============================================================================
log_info "Checking for Homebrew..."

if ! command -v brew &> /dev/null; then
    log_info "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    
    log_success "Homebrew installed successfully"
else
    log_success "Homebrew is already installed"
fi

# Update Homebrew
log_info "Updating Homebrew..."
brew update

# Function to verify if a cask exists
verify_cask_exists() {
    local cask_name=$1
    brew info --cask "$cask_name" &> /dev/null 2>&1
}

# Function to verify if a formula exists
verify_formula_exists() {
    local formula_name=$1
    brew info "$formula_name" &> /dev/null 2>&1
}

# ============================================================================
# Version Managers
# ============================================================================

# Install nvm
log_info "Installing nvm (Node Version Manager)..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    log_success "nvm installed successfully"
else
    log_success "nvm is already installed"
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Install asdf
log_info "Installing asdf..."
if ! command -v asdf &> /dev/null; then
    brew install asdf
    # Add asdf to shell
    echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc
    log_success "asdf installed successfully"
else
    log_success "asdf is already installed"
fi

# ============================================================================
# GUI Applications (via Homebrew Cask)
# ============================================================================
log_info "Installing GUI applications..."

GUI_APPS=(
    "appcleaner"
    "android-studio"
    "clop"
    "cursor"
    "google-chrome"
    "docker"
    "ghostty"
    "handbrake"
    "hiddenbar"
    "localsend"
    "obs"
    "obsidian"
    "spotify"
    "termius"
    "testflight"
    "vlc"
    "wireguard"
    "twingate"
    "xcode"
)

for app in "${GUI_APPS[@]}"; do
    if brew list --cask "$app" &> /dev/null 2>&1; then
        log_info "$app is already installed, skipping..."
    else
        # Verify cask exists before attempting installation
        if verify_cask_exists "$app"; then
            log_info "Installing $app..."
            if brew install --cask "$app" 2>&1; then
                log_success "$app installed successfully"
            else
                log_warning "Failed to install $app (installation may have failed)"
            fi
        else
            log_warning "$app cask not found in Homebrew. It may not be available or the name may be incorrect."
            log_info "You may need to install $app manually."
        fi
    fi
done

log_success "GUI applications installation complete"

# ============================================================================
# CLI Tools
# ============================================================================
log_info "Installing CLI tools..."

# Install bottom (btm)
if brew list bottom &> /dev/null 2>&1; then
    log_info "bottom (btm) is already installed, skipping..."
else
    if verify_formula_exists "bottom"; then
        log_info "Installing bottom (btm)..."
        if brew install bottom 2>&1; then
            log_success "bottom (btm) installed"
        else
            log_warning "Failed to install bottom"
        fi
    else
        log_warning "bottom formula not found in Homebrew"
    fi
fi

# Install lazydocker
if brew list lazydocker &> /dev/null 2>&1; then
    log_info "lazydocker is already installed, skipping..."
else
    if verify_formula_exists "lazydocker"; then
        log_info "Installing lazydocker..."
        if brew install lazydocker 2>&1; then
            log_success "lazydocker installed"
        else
            log_warning "Failed to install lazydocker"
        fi
    else
        log_warning "lazydocker formula not found in Homebrew"
    fi
fi

# Install gh (GitHub CLI)
if brew list gh &> /dev/null 2>&1; then
    log_info "gh (GitHub CLI) is already installed, skipping..."
else
    if verify_formula_exists "gh"; then
        log_info "Installing gh (GitHub CLI)..."
        if brew install gh 2>&1; then
            log_success "gh (GitHub CLI) installed"
        else
            log_warning "Failed to install gh"
        fi
    else
        log_warning "gh formula not found in Homebrew"
    fi
fi

# Install ngrok
if brew list ngrok &> /dev/null 2>&1; then
    log_info "ngrok is already installed, skipping..."
else
    if verify_formula_exists "ngrok"; then
        log_info "Installing ngrok..."
        if brew install ngrok 2>&1; then
            log_success "ngrok installed"
        else
            log_warning "Failed to install ngrok"
        fi
    else
        log_warning "ngrok formula not found in Homebrew"
    fi
fi

# ============================================================================
# Post-installation
# ============================================================================
log_info "Cleaning up Homebrew..."
brew cleanup

log_success "Setup complete! 🎉"
log_info "Please restart your terminal or run 'source ~/.zshrc' to use nvm and asdf"
log_warning "Note: Xcode installation via Homebrew is very large (~12GB) and may take a long time"

