<p align="center">
  <a href="https://github.com/zackbart/env">
    <img src="https://shieldcn.dev/header/graph.svg?title=env&subtitle=macOS+setup+script+for+apps+CLI+tools+fonts+and+dotfiles&logo=homebrew&mode=light&align=center&font=geist-mono&border=false" alt="env">
  </a>
</p>

<p align="center">
  <a href="https://github.com/zackbart/env/stargazers">
    <img src="https://shieldcn.dev/github/stars/zackbart/env.svg" alt="Stars">
  </a>
</p>

macOS setup script - Homebrew apps, CLI tools, fonts, and dotfiles. A curated baseline for new machines, not a mirror of any one machine.

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
| Browsers | Chrome, Helium |
| Development | Android Command-line Tools, Docker Desktop, gcloud CLI, Ghostty, LM Studio, T3 Code (nightly) |
| AI & Productivity | Buzz, Claude, FluidVoice, Granola, Notion, Notion Calendar, Obsidian |
| Design | Figma |
| Markdown | Markdown Preview |
| Utilities | AppCleaner, balenaEtcher, Barr, Clop, Loadout, LocalSend, OpenUsage, PureMac, RustDesk, Stillcolor, WiFiman, Windo |
| Media | Anki, HandBrake, OBS, Spotify, VLC |
| Networking | mitmproxy, Mullvad VPN, ngrok, Tailscale, Twingate, VB-Cable |
| Communication & remote | Discord, Parsec, Zoom |
| Database | TablePro |
| Virtualization | UTM |
| CLI (cask) | Codex, Cursor CLI |

### Fonts

Homebrew casks - these account for 132 of the files in `~/Library/Fonts`:

- JetBrains Mono
- JetBrains Mono Nerd Font
- Symbols Only Nerd Font

Faces with no cask are vendored in [`fonts/`](fonts/) and copied to `~/Library/Fonts`:

- Ace Sans (demo)
- FFF Acid Grotesk Soft (variable)
- Garnet Capitals Black

The script globs `*.otf`, `*.ttf`, `*.ttc`, `*.woff2` from that directory, so
adding a face is just dropping the file in - no list to edit. To go the other
way and pull user fonts off a machine back into the repo:

```bash
./fonts/sync.sh --dry-run   # list what it would copy
./fonts/sync.sh             # copy them in
```

It diffs `~/Library/Fonts` against the cask artifact lists and skips anything
Homebrew already owns. See [`fonts/README.md`](fonts/README.md) for the
licensing rule - this repo is public, so only redistributable faces belong here.

### CLI Tools (Homebrew Formulae)

| Category | Tools |
|----------|-------|
| Shell & prompt | starship, zoxide, fzf, tmux |
| Modern coreutils | bat, eza, fd, ripgrep, difftastic |
| Git | gh, lazygit |
| Monitoring | bottom |
| Docker | lazydocker |
| Languages & runtimes | node + [nub](https://nubjs.com) (the whole JS story - installs, scripts, dlx, globals, pinned versions), go, openjdk@17, uv (the whole Python story) |
| Data | jq, duckdb |
| Media | ffmpeg (homebrew-ffmpeg build), imagemagick, handbrake |
| Documents | pandoc |
| Cloud & deploy | supabase, stripe, railway, firebase-cli, googleworkspace-cli |
| Security | gnupg |
| Database client | libpq |
| Apple / iOS dev | xcodegen, libimobiledevice, molten-vk, cocoapods, axe, xcodebuildmcp |
| AI coding agents | opencode |
| Utilities | cloc, dust, mole, herdr, sevenzip, summarize, mas, agent-browser |
| Tap tools (zackbart) | cleenup, dbseer, seer |

### Global JS CLIs (via nub)

skills, vercel, wrangler - installed with `nub add -g`, living in `~/Library/pnpm` decoupled from any Node version.

### Global npm CLIs

clerk - npm-only, so it goes in via `npm install -g`. Everything else that *can* come from Homebrew does (notably `agent-browser`: brew is the source of truth, don't also `npm i -g` it).

### External Installers

- **rustup** - the Rust toolchain (no brew `rust`)
- **Claude Code** - native installer (`claude.ai/install.sh`)

### Claude Code Skills & Plugins

Follow [`claude/SETUP.md`](claude/SETUP.md) - plugins (claude-hud, motif), the nub-powered claude-hud statusline, and global skills.

- **Skills record:** https://github.com/zackbart/skills
- **Plugins:** https://github.com/zackbart/agent-plugins

### Dotfiles

The script copies these from `dotfiles/` to their proper locations:

- `.zshrc` → `~/.zshrc`
- `.gitconfig` → `~/.gitconfig`
- `starship.toml` → `~/.config/starship.toml`
- `ghostty/config` → `~/.config/ghostty/config`
- `ghostty/themes/*` → `~/.config/ghostty/themes/` (every file in the dir: `greyscale-{light,dark}`, `catppuccin-{latte,mocha}`)
- `AGENTS.md` → `~/AGENTS.md`, plus a `~/CLAUDE.md` → `AGENTS.md` symlink

That last one is the global agent instruction file. One source, two names: Claude Code reads `~/CLAUDE.md`, Codex and opencode read `~/AGENTS.md`, and the symlink stops them drifting apart.

Existing files that differ are backed up with a `.bak` extension. Machine-local secrets go in `~/.zshrc.local` (sourced if present, never committed).

`~/.zprofile` (brew shellenv) and `~/.zshenv` (cargo env) are not tracked - the Homebrew and rustup installers regenerate them.

### Mac App Store (via mas)

Amphetamine, WireGuard, TestFlight, Xcode, Apple Developer, Plash, Blackmagic Disk Speed Test, Keynote, Numbers, Pages

### Manual Installs

- **DaVinci Resolve** - https://www.blackmagicdesign.com/products/davinciresolve (also brings Blackmagic Proxy Generator + Blackmagic RAW)
- **Send to Kindle** - https://www.amazon.com/sendtokindle (brew cask disabled upstream)
- **Codex desktop app** - https://openai.com/codex (the `codex-app` cask is deprecated upstream; installs as `ChatGPT.app`, separate from the `codex` CLI cask)
- **GatherV2** - direct download
- **Paper** - direct download
- **Supaste** - direct download

### Not Handled Here

Auth and state that has to be re-authed or hand-carried: `~/.ssh`, `~/.npmrc`, `~/.claude.json`, `~/.codex/auth.json`, `~/Library/Android/sdk`, and the gcloud/gh/supabase/stripe/railway/firebase logins.

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
- Some casks (Mullvad VPN, Tailscale, VB-Cable, WiFiman, Zoom) require sudo for pkg installers - brew will prompt for your password
- Restart your terminal after running to apply shell config
