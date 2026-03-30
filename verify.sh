#!/bin/bash

# Verification script — checks all Homebrew casks and formulas exist before install

echo "Verifying Homebrew casks and formulas..."
echo ""

if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed."
    exit 1
fi

echo "Updating Homebrew and adding taps..."
brew update > /dev/null 2>&1
brew tap steipete/tap 2>/dev/null || true
brew tap zackbart/tap 2>/dev/null || true
brew tap yakitrak/yakitrak 2>/dev/null || true
brew tap stripe/stripe-cli 2>/dev/null || true
brew tap supabase/tap 2>/dev/null || true

CASK_APPS=(
    "google-chrome"
    "android-studio"
    "docker-desktop"
    "ghostty"
    "lm-studio"
    "visual-studio-code"
    "claude"
    "cmux"
    "obsidian"
    "notion-calendar"
    "superset"
    "appcleaner"
    "balenaetcher"
    "clop"
    "cyberduck"
    "handy"
    "localsend"
    "rustdesk"
    "send-to-kindle"
    "wifiman"
    "anki"
    "handbrake-app"
    "obs"
    "spotify"
    "vlc"
    "mitmproxy"
    "mullvad-vpn"
    "ngrok"
    "termius"
    "twingate"
    "vb-cable"
    "discord"
    "zoom"
    "beekeeper-studio"
    "heroic"
    "utm"
    "claude-code"
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
    "yazi"
    "superfile"
    "bottom"
    "lazydocker"
    "asdf"
    "node"
    "pnpm"
    "go"
    "openjdk@17"
    "python@3.14"
    "uv"
    "typescript"
    "typescript-language-server"
    "pyright"
    "jq"
    "duckdb"
    "ffmpeg"
    "imagemagick"
    "sox"
    "pandoc"
    "poppler"
    "supabase"
    "stripe"
    "railway"
    "firebase-cli"
    "sentry-cli"
    "trufflehog"
    "gnupg"
    "certbot"
    "chafa"
    "resvg"
    "libpq"
    "cloc"
    "happy-coder"
    "sevenzip"
    "opencode"
    "mas"
    "steipete/tap/imsg"
    "steipete/tap/summarize"
    "zackbart/tap/cleenup"
    "zackbart/tap/seer"
    "zackbart/tap/werk"
    "yakitrak/yakitrak/obsidian-cli"
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
