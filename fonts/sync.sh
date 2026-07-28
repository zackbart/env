#!/bin/bash

# Copies user-installed fonts from ~/Library/Fonts into this directory.
# A font counts as "user-installed" if no Homebrew font cask ships a file with
# the same name — those are handled by `brew install --cask` in setup.sh and
# would only bloat the repo.

set -u

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info()    { echo -e "${BLUE}i${NC} $1"; }
log_success() { echo -e "${GREEN}+${NC} $1"; }
log_warning() { echo -e "${YELLOW}!${NC} $1"; }

FONTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HOME/Library/Fonts"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

if [ ! -d "$SRC" ]; then
    log_warning "$SRC does not exist — nothing to sync"
    exit 0
fi

# Every filename Homebrew's font casks own, so we can skip them. Font casks move
# the file into ~/Library/Fonts and leave a symlink in the Caskroom, so the
# authoritative list is `brew list --cask`, not a find over real files.
BREW_FONT_CASKS="$(brew list --cask 2>/dev/null | grep '^font-')"
BREW_FONTS=""
if [ -n "$BREW_FONT_CASKS" ]; then
    # shellcheck disable=SC2086
    BREW_FONTS="$(brew list --cask $BREW_FONT_CASKS 2>/dev/null \
        | grep -iE '\.(otf|ttf|ttc|woff2)$' \
        | while IFS= read -r p; do basename "$p"; done | sort -u)"
fi

if [ -z "$BREW_FONTS" ]; then
    log_warning "Could not read Homebrew font casks — every font will be treated as user-installed"
fi

shopt -s nullglob
copied=0
skipped=0

for font in "$SRC"/*.otf "$SRC"/*.ttf "$SRC"/*.ttc "$SRC"/*.woff2; do
    name="$(basename "$font")"

    if grep -qxF "$name" <<< "$BREW_FONTS"; then
        skipped=$((skipped + 1))
        continue
    fi

    dest="$FONTS_DIR/$name"
    if [ -f "$dest" ] && cmp -s "$font" "$dest"; then
        continue
    fi

    if $DRY_RUN; then
        log_warning "WOULD copy $name"
    else
        cp "$font" "$dest"
        log_success "Copied $name"
    fi
    copied=$((copied + 1))
done

shopt -u nullglob

echo ""
log_info "$skipped font(s) skipped (Homebrew-managed)"
if [ "$copied" -eq 0 ]; then
    log_success "Already in sync"
elif $DRY_RUN; then
    log_info "$copied font(s) would be copied — rerun without --dry-run"
else
    log_success "$copied font(s) copied into fonts/"
    log_warning "Check each face's license before committing — this repo is public"
fi
