# macOS Setup Script

A robust setup script for configuring a new M5 Mac with essential development tools and applications.

## What This Script Does

1. **Installs Homebrew** - Package manager for macOS
2. **Installs Version Managers**:
   - nvm (Node Version Manager)
   - asdf (Extendable version manager)
3. **Installs GUI Applications** (via Homebrew Cask):
   - App Cleaner
   - Android Studio
   - Clop
   - Cursor
   - Chrome
   - Docker Desktop
   - Ghostty
   - Handbrake
   - Hidden Bar
   - LocalSend
   - OBS
   - Obsidian
   - Spotify
   - Termius
   - TestFlight
   - VLC
   - WireGuard
   - Twingate
   - Xcode (requires manual installation via App Store)
4. **Installs CLI Tools**:
   - bottom (btm) - System monitor
   - lazydocker - Docker management tool

## Usage

1. Make the script executable:
   ```bash
   chmod +x setup.sh
   ```

2. Run the script:
   ```bash
   ./setup.sh
   ```

The script is idempotent - you can run it multiple times safely. It will skip already installed packages.

## Notes

- **Xcode** must be installed manually via the App Store or by running `xcode-select --install`
- After running the script, restart your terminal or run `source ~/.zshrc` to use nvm and asdf
- Some applications may require manual configuration after installation

## Requirements

- macOS (optimized for Apple Silicon/M5)
- Internet connection
- Administrator privileges (for Homebrew installation)

