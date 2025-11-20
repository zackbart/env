#!/bin/bash

# Verification script to check if all Homebrew casks and formulas exist

set -e

echo "🔍 Verifying Homebrew casks and formulas..."
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew is not installed. Please install it first."
    exit 1
fi

# Update Homebrew to get latest cask information
echo "📦 Updating Homebrew..."
brew update > /dev/null 2>&1

# GUI Applications to verify
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

# CLI Tools to verify
CLI_TOOLS=(
    "bottom"
    "lazydocker"
)

echo "🔎 Checking GUI applications (casks)..."
echo "----------------------------------------"
FAILED_CASKS=()
for app in "${GUI_APPS[@]}"; do
    if brew info --cask "$app" &> /dev/null; then
        echo "✅ $app - Available"
    else
        echo "❌ $app - NOT FOUND"
        FAILED_CASKS+=("$app")
    fi
done

echo ""
echo "🔎 Checking CLI tools (formulas)..."
echo "----------------------------------------"
FAILED_FORMULAS=()
for tool in "${CLI_TOOLS[@]}"; do
    if brew info "$tool" &> /dev/null; then
        echo "✅ $tool - Available"
    else
        echo "❌ $tool - NOT FOUND"
        FAILED_FORMULAS+=("$tool")
    fi
done

echo ""
echo "📊 Summary"
echo "----------------------------------------"
if [ ${#FAILED_CASKS[@]} -eq 0 ] && [ ${#FAILED_FORMULAS[@]} -eq 0 ]; then
    echo "✅ All casks and formulas are available!"
    exit 0
else
    echo "❌ Some items were not found:"
    if [ ${#FAILED_CASKS[@]} -gt 0 ]; then
        echo "   Failed casks: ${FAILED_CASKS[*]}"
    fi
    if [ ${#FAILED_FORMULAS[@]} -gt 0 ]; then
        echo "   Failed formulas: ${FAILED_FORMULAS[*]}"
    fi
    exit 1
fi

