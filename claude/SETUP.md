# Claude Code setup

Agent-followable guide to restore the Claude Code environment on a new machine.
`setup.sh` installs the `claude` binary (native installer) and `nub` (Homebrew) — both are prerequisites here.

## 1. Plugins

Two plugins, both from the `zackbart/agent-plugins` marketplace, installed at user scope:

| Plugin | What it is |
|--------|------------|
| `claude-hud` | Statusline HUD (context bar, model, git, motif stage) |
| `motif` | Personal dev workflow orchestrator (Research → Plan → Build → Validate) |

Inside a Claude Code session:

```
/plugin marketplace add zackbart/agent-plugins
/plugin install claude-hud@agent-plugins
/plugin install motif@agent-plugins
```

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
| `grill-me` | zackbart/skills |
| `info-html` | zackbart/skills |
| `scratch-html` | zackbart/skills |

```bash
skills add vercel-labs/agent-browser -g -y
skills add anthropics/skills@frontend-design -g -y
skills add zackbart/skills -g -y   # grill-me, info-html, scratch-html
```

The canonical record of skills (and their sources) lives in
[zackbart/skills](https://github.com/zackbart/skills) — check it before trusting
the table above, and keep them in sync.

## 4. settings.json

The full Claude Code config is snapshotted at [`settings.json`](settings.json) — restore with:

```bash
cp claude/settings.json ~/.claude/settings.json
```

What's in it (so you know what you're restoring):

- `env` — adaptive thinking off, auto-memory off, no-flicker, subagent model inherits
- `permissions.defaultMode: bypassPermissions` + a deny list (notifications, cron, SendMessage, …)
- `model: claude-fable-5[1m]`, `effortLevel: high`
- `disableBundledSkills`, `disableArtifact`, `theme: light`, voice/push off
- `hooks` — `PostToolUse`/ExitPlanMode → `~/.claude/hooks/plan-review.sh`; `SessionStart` → `~/.claude/hooks/herdr-agent-state.sh`
- `statusLine` — the nub command from section 2
- `enabledPlugins` — claude-hud, motif (agent-plugins) + context7 (official)
- `extraKnownMarketplaces` — zackbart/agent-plugins with autoUpdate

The two hook scripts are snapshotted in [`hooks/`](hooks/) — restore alongside:

```bash
mkdir -p ~/.claude/hooks && cp claude/hooks/*.sh ~/.claude/hooks/
```

Re-snapshot `settings.json`, `hooks/`, and `claude-hud.config.json` here whenever they change on the machine.

## 5. The rest

- `~/.claude/CLAUDE.md` — user-level instructions; copy from the old machine.
- MCP servers — per-project via the `mcp-sync` skill (`MCP.md` at each repo root).
