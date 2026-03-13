# env

macOS setup script — Homebrew apps, CLI tools, fonts, and dotfiles.

## Quick Start

```bash
git clone https://github.com/zackbart/env.git ~/env && cd ~/env && chmod +x setup.sh && ./setup.sh
```

Without git:

```bash
curl -fsSL https://raw.githubusercontent.com/zackbart/env/main/setup.sh -o /tmp/setup.sh && chmod +x /tmp/setup.sh && /tmp/setup.sh
```

## What It Installs

### GUI Apps (Homebrew Casks)

| Category | Apps |
|----------|------|
| Browsers | Chrome |
| Development | Cursor, Docker Desktop, Ghostty, LM Studio |
| Productivity | Obsidian, Granola, Claude, Paper, Superset |
| Utilities | AppCleaner, Clop, Handy, LocalSend, Cyberduck, balenaEtcher, RustDesk, WiFiman, Send to Kindle |
| Media production | NDI Tools |
| Media | HandBrake, OBS, Spotify, VLC |
| Networking | Tailscale, Termius, Twingate, ngrok |
| Communication | Zoom |
| Database | Beekeeper Studio |
| Virtualization | UTM |
| CLI (cask) | Claude Code, Codex, gcloud CLI |

### Fonts

- JetBrains Mono
- JetBrains Mono Nerd Font
- Symbols Only Nerd Font

### CLI Tools (Homebrew Formulae)

| Category | Tools |
|----------|-------|
| Shell & prompt | starship, zoxide, fzf |
| Modern coreutils | bat, eza, fd, ripgrep |
| Git | gh, lazygit |
| File manager | yazi |
| Monitoring | bottom |
| Docker | lazydocker |
| Languages | node, pnpm, go, openjdk |
| Data | jq, duckdb |
| Media | ffmpeg, imagemagick |
| Images & rendering | chafa, resvg |
| Documents | pandoc, poppler |
| Database client | libpq |
| Cloud & deploy | supabase, stripe, railway |
| Security | trufflehog, gnupg |
| Utilities | cloc, sevenzip, opencode |
| Tap tools | summarize, cleenup, seer, werk, obsidian-cli, kotlin-lsp |

### Global npm Packages

@dbml/cli, @googleworkspace/cli, agent-browser, defuddle, pyright, skills, slopmeter, typescript, typescript-language-server

### Dotfiles

The script symlinks these from `dotfiles/` to their proper locations:

- `.zshrc` → `~/.zshrc`
- `.gitconfig` → `~/.gitconfig`
- `starship.toml` → `~/.config/starship.toml`
- `ghostty/config` → `~/.config/ghostty/config`

Existing files are backed up with a `.bak` extension.

### Mac App Store (via mas)

Amphetamine, Hidden Bar, WireGuard, TestFlight

### Manual Installs

- **DaVinci Resolve** — https://www.blackmagicdesign.com/products/davinciresolve
- **Notchi** — https://lo.cafe/notchi
- **Readout** — https://readout.app
- **OpenPencil** — https://github.com/nicktmro/OpenPencil
- **OpenUsage** — https://github.com/nicktmro/OpenUsage
- **FnMacAssistant** — https://github.com/nicktmro/FnMacAssistant

## Verify Before Install

```bash
./verify.sh
```

Checks that all casks and formulas are available in Homebrew before you run setup.

## Notes

- Idempotent — safe to run multiple times
- Optimized for Apple Silicon
- Restart your terminal after running to apply shell config
