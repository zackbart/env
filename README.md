# env

macOS setup script - Homebrew apps, CLI tools, fonts, and dotfiles.

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
| Development | Android Studio, Docker Desktop, Ghostty, LM Studio, VS Code |
| AI & Productivity | Claude, cmux, Obsidian, Notion Calendar, Superset |
| Utilities | AppCleaner, balenaEtcher, Clop, Cyberduck, Handy, LocalSend, RustDesk, Send to Kindle, WiFiman |
| Media | Anki, HandBrake, OBS, Spotify, VLC |
| Networking | mitmproxy, Mullvad VPN, ngrok, Termius, Twingate, VB-Cable |
| Communication | Discord, Zoom |
| Database | Beekeeper Studio |
| Gaming | Heroic |
| Virtualization | UTM |
| CLI (cask) | Claude Code, Codex, Cursor CLI |

### Fonts

- JetBrains Mono
- JetBrains Mono Nerd Font
- Symbols Only Nerd Font

### CLI Tools (Homebrew Formulae)

| Category | Tools |
|----------|-------|
| Shell & prompt | starship, zoxide, fzf, tmux |
| Modern coreutils | bat, eza, fd, ripgrep, difftastic |
| Git | gh, lazygit |
| File managers | yazi, superfile |
| Monitoring | bottom |
| Docker | lazydocker |
| Languages & runtimes | asdf, node, pnpm, go, openjdk@17, python@3.14, uv |
| TypeScript & Python tooling | typescript, typescript-language-server, pyright |
| Data | jq, duckdb |
| Media | ffmpeg, imagemagick, sox |
| Documents | pandoc, poppler |
| Cloud & deploy | supabase, stripe, railway, firebase-cli, sentry-cli |
| Security | trufflehog, gnupg, certbot |
| Images & rendering | chafa, resvg |
| Database client | libpq |
| Utilities | cloc, happy-coder, sevenzip, opencode, mas |
| Tap tools | imsg, summarize, cleenup, seer, werk, obsidian-cli |

### Global npm Packages

@dbml/cli, @googleworkspace/cli, @steipete/bird, agent-browser, defuddle, playwriter, skills

### Claude Code Skills & Plugins

Managed separately:

- **Skills:** https://github.com/zackbart/skills
- **Plugins:** https://github.com/zackbart/agent-plugins

### Dotfiles

The script symlinks these from `dotfiles/` to their proper locations:

- `.zshrc` → `~/.zshrc`
- `.gitconfig` → `~/.gitconfig`
- `starship.toml` → `~/.config/starship.toml`
- `ghostty/config` → `~/.config/ghostty/config`

Existing files are backed up with a `.bak` extension.

### Mac App Store (via mas)

Amphetamine, Hidden Bar, WireGuard, TestFlight, Xcode

### Manual Installs

- **DaVinci Resolve** - https://www.blackmagicdesign.com/products/davinciresolve
- **Blackmagic RAW** - https://www.blackmagicdesign.com/products/blackmagicraw
- **Chops** - Direct download
- **Clearly** - https://github.com/Shpigford/clearly
- **OpenOats** - https://github.com/yazinsai/OpenOats
- **OpenUsage** - https://github.com/robinebers/openusage
- **Unbreakable** - Direct download
- **Shift** - Direct download
- **Rust (rustup)** - https://rustup.rs
- **Bun** - https://bun.sh

## Dry Run

```bash
./setup.sh --dry-run
```

Preview what would be installed without making changes.

## Verify Before Install

```bash
./verify.sh
```

Checks that all casks and formulas are available in Homebrew before you run setup.

## Notes

- Idempotent - safe to run multiple times
- Optimized for Apple Silicon
- Some casks (Mullvad VPN, Send to Kindle, VB-Cable, WiFiman, Zoom) require sudo for pkg installers - brew will prompt for your password
- Restart your terminal after running to apply shell config
