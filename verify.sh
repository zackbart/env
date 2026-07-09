#!/bin/bash

# Verification script — checks all Homebrew casks and formulas exist before install
# Keep the lists in sync with setup.sh

echo "Verifying Homebrew casks and formulas..."
echo ""

if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed."
    exit 1
fi

echo "Updating Homebrew and adding taps..."
brew update > /dev/null 2>&1
brew tap zackbart/tap 2>/dev/null || true
brew tap stripe/stripe-cli 2>/dev/null || true
brew tap supabase/tap 2>/dev/null || true
brew tap anomalyco/tap 2>/dev/null || true
brew tap homebrew-ffmpeg/ffmpeg 2>/dev/null || true
brew tap pluk-inc/tap 2>/dev/null || true
brew tap cameroncooke/axe 2>/dev/null || true
brew tap getsentry/xcodebuildmcp 2>/dev/null || true
brew tap nubjs/tap 2>/dev/null || true

CASK_APPS=(
    "google-chrome"
    "helium-browser"
    "android-commandlinetools"
    "docker-desktop"
    "gcloud-cli"
    "ghostty"
    "lm-studio"
    "t3-code"
    "claude"
    "fluidvoice"
    "granola"
    "notion"
    "notion-calendar"
    "obsidian"
    "raycast"
    "figma"
    "markdown-preview"
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
    "anki"
    "handbrake-app"
    "obs"
    "spotify"
    "vlc"
    "mitmproxy"
    "mullvad-vpn"
    "ngrok"
    "tailscale-app"
    "twingate"
    "vb-cable"
    "discord"
    "zoom"
    "tablepro"
    "utm"
    "codex"
    "cursor-cli"
    "font-jetbrains-mono"
    "font-jetbrains-mono-nerd-font"
    "font-symbols-only-nerd-font"
)

CLI_TOOLS=(
    "starship"
    "zoxide"
    "fzf"
    "tmux"
    "bat"
    "eza"
    "fd"
    "ripgrep"
    "difftastic"
    "gh"
    "lazygit"
    "bottom"
    "lazydocker"
    "node"
    "nubjs/tap/nub"
    "go"
    "openjdk@17"
    "uv"
    "jq"
    "duckdb"
    "homebrew-ffmpeg/ffmpeg/ffmpeg"
    "imagemagick"
    "handbrake"
    "pandoc"
    "supabase"
    "stripe"
    "railway"
    "firebase-cli"
    "gnupg"
    "libpq"
    "cloc"
    "dust"
    "mole"
    "herdr"
    "sevenzip"
    "summarize"
    "mas"
    "agent-browser"
    "anomalyco/tap/opencode"
    "xcodegen"
    "libimobiledevice"
    "molten-vk"
    "cocoapods"
    "cameroncooke/axe/axe"
    "getsentry/xcodebuildmcp/xcodebuildmcp"
    "googleworkspace-cli"
    "zackbart/tap/cleenup"
    "zackbart/tap/dbseer"
    "zackbart/tap/seer"
)

echo "Checking casks..."
echo "----------------------------------------"
FAILED_CASKS=()
for app in "${CASK_APPS[@]}"; do
    if brew info --cask "$app" &> /dev/null; then
        echo "  $app"
    else
        echo "  MISSING: $app"
        FAILED_CASKS+=("$app")
    fi
done

echo ""
echo "Checking formulas..."
echo "----------------------------------------"
FAILED_FORMULAS=()
for tool in "${CLI_TOOLS[@]}"; do
    if brew info "$tool" &> /dev/null; then
        echo "  $tool"
    else
        echo "  MISSING: $tool"
        FAILED_FORMULAS+=("$tool")
    fi
done

echo ""
echo "Summary"
echo "----------------------------------------"
if [ ${#FAILED_CASKS[@]} -eq 0 ] && [ ${#FAILED_FORMULAS[@]} -eq 0 ]; then
    echo "All casks and formulas are available."
    exit 0
else
    echo "Some items were not found:"
    [ ${#FAILED_CASKS[@]} -gt 0 ] && echo "  Casks: ${FAILED_CASKS[*]}"
    [ ${#FAILED_FORMULAS[@]} -gt 0 ] && echo "  Formulas: ${FAILED_FORMULAS[*]}"
    exit 1
fi
