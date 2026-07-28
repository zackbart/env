# User fonts

Font files that aren't available as a Homebrew cask. `setup.sh` copies everything
here into `~/Library/Fonts` on a fresh machine.

Homebrew-managed faces are **not** kept here — they're casks in `setup.sh`:

| Face | Source |
| --- | --- |
| JetBrains Mono | `font-jetbrains-mono` |
| JetBrains Mono Nerd Font | `font-jetbrains-mono-nerd-font` |
| Symbols Only Nerd Font | `font-symbols-only-nerd-font` |

Those three account for 132 of the 135 files in `~/Library/Fonts`. Only the
remainder lives in this directory.

## Adding a font

Drop the file in. `setup.sh` globs `*.otf`, `*.ttf`, `*.ttc`, `*.woff2` — there's
no list to edit.

## Re-syncing from this machine

`./sync.sh` diffs `~/Library/Fonts` against the Homebrew Caskroom and copies any
font Homebrew doesn't own into this directory. Run it before a machine swap to
catch faces installed since the last commit.

```sh
./fonts/sync.sh            # copy new user fonts into the repo
./fonts/sync.sh --dry-run  # list what it would copy
```

## Licensing

This repo is public. Only commit faces you're allowed to redistribute — demo,
open-source (OFL/Apache), or self-hosted-license fonts. For anything under a
commercial EULA that forbids redistribution, either keep the file untracked
(`echo 'fonts/Name.ttf' >> .gitignore`) and carry it over by hand, or move the
whole directory into a private repo and point `setup.sh` at it.
