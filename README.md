# macOS Setup Script

A robust setup script for configuring a new M5 Mac with essential development tools and applications.

## Quick Start (One-Liner)

Paste this into your terminal to clone and run the setup script:

```bash
git clone https://github.com/zackbart/env.git ~/env-setup && cd ~/env-setup && chmod +x setup.sh && ./setup.sh
```

Or if you already have the repo cloned:

```bash
cd ~/env-setup && chmod +x setup.sh && ./setup.sh
```

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
   - Xcode
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

## Verification

Before running the setup script, you can verify that all Homebrew casks and formulas are available:

```bash
./verify.sh
```

This will check if all applications and tools can be found in Homebrew before attempting installation.

## Notes

- **Xcode** installation via Homebrew is very large (~12GB) and may take a long time
- After running the script, restart your terminal or run `source ~/.zshrc` to use nvm and asdf
- Some applications may require manual configuration after installation
- The script includes verification checks to ensure casks/formulas exist before installation

## Requirements

- macOS (optimized for Apple Silicon/M5)
- Internet connection
- Administrator privileges (for Homebrew installation)

