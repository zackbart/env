# Claude Code setup

Agent-followable guide to restore the Claude Code environment on a new machine.
`setup.sh` installs the `claude` binary (native installer) and `nub` (Homebrew) — both are prerequisites here.

## 1. Plugins

Two marketplaces: `zackbart/agent-plugins` (personal) and `claude-plugins-official` (bundled).

| Plugin | Marketplace | Scope | Enabled | What it is |
|--------|-------------|-------|---------|------------|
| `claude-hud` | agent-plugins | user | yes | Statusline HUD (context bar, model, git, motif stage) |
| `motif` | agent-plugins | user | **no** | Dev workflow orchestrator (Research → Plan → Build → Validate) — installed but currently disabled |
| `context7` | official | user | yes | Live library docs MCP |
| `vercel` | official | local (`~`) | — | Vercel tooling |
| `plugin-dev` | official | local (`~`) | — | Plugin authoring helpers |

Inside a Claude Code session:

```
/plugin marketplace add zackbart/agent-plugins
/plugin install claude-hud@agent-plugins
/plugin install motif@agent-plugins
/plugin install context7@claude-plugins-official
/plugin install vercel@claude-plugins-official
/plugin install plugin-dev@claude-plugins-official
```

`settings.json` (section 4) decides which are actually *enabled* — restoring it leaves
`motif` installed but off, matching the current machine.

## 2. claude-hud statusline

claude-hud runs as a TypeScript statusline command executed by **nub** (no bun/tsx needed —
nub runs `.ts` on stock Node). Wire it into `~/.claude/settings.json`:

```json
{
  "statusLine": {
    "type": "command",
    "command": "bash -c 'plugin_dir=$(ls -d \"${CLAUDE_CONFIG_DIR:-$HOME/.claude}\"/plugins/cache/agent-plugins/claude-hud/*/ 2>/dev/null | awk -F/ '\"'\"'{ print $(NF-1) \"\\t\" $(0) }'\"'\"' | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n | tail -1 | cut -f2-); exec \"/opt/homebrew/bin/nub\" \"${plugin_dir}src/index.ts\"'"
  }
}
```

(The `ls | sort | tail` dance picks the highest installed plugin version.)

Then restore the HUD display config:

```bash
mkdir -p ~/.claude/plugins/claude-hud
cp claude/claude-hud.config.json ~/.claude/plugins/claude-hud/config.json
```

The tracked copy at [`claude-hud.config.json`](claude-hud.config.json) is the source of truth —
re-snapshot it here when the HUD config changes.

## 3. Global skills

Installed globally via the [`skills`](https://github.com/vercel-labs/skills) CLI
(itself installed by `setup.sh` via `nub add -g skills`). Current set:

| Skill | Source |
|-------|--------|
| `agent-browser` | vercel-labs/agent-browser |
| `frontend-design` | anthropics/skills |
| `confer` | zackbart/skills (`agent-tools/confer`) |
| `info-html` | zackbart/skills (`preferences/info-html`) |
| `models` | zackbart/skills (`agent-tools/models`) |
| `scratch-html` | zackbart/skills (`agent-tools/scratch-html`) |
| `grill-me` | mattpocock/skills (`skills/productivity/grill-me`) |
| `i-have-adhd` | ayghri/i-have-adhd |

```bash
skills add vercel-labs/agent-browser -g -y
skills add anthropics/skills@frontend-design -g -y
skills add zackbart/skills -g -y            # confer, info-html, models, scratch-html
skills add mattpocock/skills@grill-me -g -y
skills add ayghri/i-have-adhd -g -y
```

Skills install into `~/.agents/skills/` and are symlinked into `~/.claude/skills/`.
`~/.agents/.skill-lock.json` is the authoritative record of what's installed and where
each one came from — trust it over this table, and keep the two in sync.
The personal ones also live in [zackbart/skills](https://github.com/zackbart/skills).

## 4. settings.json

The full Claude Code config is snapshotted at [`settings.json`](settings.json) — restore with:

```bash
cp claude/settings.json ~/.claude/settings.json
```

What's in it (so you know what you're restoring):

- `env` — adaptive thinking off, auto-memory off, no-flicker, subagent model inherits
- `permissions.defaultMode: bypassPermissions` + a deny list (notifications, cron, SendMessage, …)
- no `model` pin (rides the CLI default), `effortLevel: high`
- `disableBundledSkills`, `disableArtifact`, `theme: auto`, voice/push off
- `hooks` — `PostToolUse`/ExitPlanMode → `~/.claude/hooks/plan-review.sh`; `SessionStart` → `~/.claude/hooks/herdr-agent-state.sh`
- `statusLine` — the nub command from section 2
- `enabledPlugins` — claude-hud (agent-plugins) + context7 (official)
- `extraKnownMarketplaces` — zackbart/agent-plugins with autoUpdate

The two hook scripts are snapshotted in [`hooks/`](hooks/) — restore alongside:

```bash
mkdir -p ~/.claude/hooks && cp claude/hooks/*.sh ~/.claude/hooks/
```

Re-snapshot `settings.json`, `hooks/`, and `claude-hud.config.json` here whenever they change on the machine.

## 5. The rest

- **Global agent instructions** — handled by `setup.sh`, not this file. It copies
  `dotfiles/AGENTS.md` → `~/AGENTS.md` and symlinks `~/CLAUDE.md` → `AGENTS.md`, so
  Claude Code and the Codex/opencode side read the same file.
- **MCP servers** — no user-scope servers. Per-project only (`paper`, `xcodebuild` in the
  iOS repos), managed via the `mcp-sync` skill / `MCP.md` at each repo root.
- **`~/.claude.json`** — auth, onboarding state, per-project MCP config. Contains live
  tokens; never commit it. Carry it over by hand or just re-auth.
