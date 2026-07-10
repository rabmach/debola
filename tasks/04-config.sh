#!/usr/bin/env bash
### part of the DORiS suite of goodness - debian openbox restoration script(s) - 2026 machiner
# 04-config.sh - Configuration restoration
#

set -Euo pipefail
export DEBOLA_DIR="${DEBOLA_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$DEBOLA_DIR/lib.sh"

header "CONFIGURATION RESTORATION"

RESTORE_COUNT=0

# ── ~/.config/ ──────────────────────────────────────────────
if [[ -d "$DEBOLA_DIR/config" ]]; then
    log "Restoring ~/.config/ from debola/config/..."
    ensure_dir "$CURRENT_HOME/.config"
    for item in "$DEBOLA_DIR/config/"*; do
        name=$(basename "$item")
        target="$CURRENT_HOME/.config/$name"
        if [[ -d "$item" ]]; then
            backup_and_copy_dir "$item" "$target"
        else
            backup_and_copy "$item" "$target"
        fi
        ((RESTORE_COUNT++))
    done
    log "  Restored $RESTORE_COUNT items to ~/.config/"
fi

# ── $USER replacement in config files ────────────────────────
REPLACE_FILES=(
    "$CURRENT_HOME/.config/wallpapers.cfg"
    "$CURRENT_HOME/.config/pianobar/config"
    "$CURRENT_HOME/.config/gtk-3.0/bookmarks"
    "$CURRENT_HOME/.config/lxpanel/default/panels/panel"
    "$CURRENT_HOME/.config/openbox/menu.xml"
    "$CURRENT_HOME/.config/Thunar/uca.xml"
)
log "Replacing \$USER tokens in config files..."
for f in "${REPLACE_FILES[@]}"; do
    if [[ -f "$f" ]]; then
        replace_user "$f"
    fi
done

# ── ~/bin/ ────────────────────────────────────────────────────
if [[ -d "$DEBOLA_DIR/bin" ]]; then
    log "Restoring ~/bin/ from debola/bin/..."
    ensure_dir "$CURRENT_HOME/bin"
    for item in "$DEBOLA_DIR/bin/"*; do
        name=$(basename "$item")
        backup_and_copy "$item" "$CURRENT_HOME/bin/$name"
    done
    chmod -R +x "$CURRENT_HOME/bin/"
    log "  Set executable permissions on ~/bin/"

    # $USER replacement in bin/frank
    if [[ -f "$CURRENT_HOME/bin/frank" ]]; then
        replace_user "$CURRENT_HOME/bin/frank"
    fi
fi

# ── ~/.local/share/ ───────────────────────────────────────────
if [[ -d "$DEBOLA_DIR/local/share" ]]; then
    log "Restoring ~/.local/share/ from debola/local/share/..."
    for item in "$DEBOLA_DIR/local/share/"*; do
        name=$(basename "$item")
        target="$CURRENT_HOME/.local/share/$name"
        if [[ -d "$item" ]]; then
            backup_and_copy_dir "$item" "$target"
        else
            backup_and_copy "$item" "$target"
        fi
    done

    if [[ -d "$CURRENT_HOME/.local/share/scripts" ]]; then
        chmod -R +x "$CURRENT_HOME/.local/share/scripts/"
        log "  Set executable permissions on ~/.local/share/scripts/"
    fi
fi

# ── Hidden files from home/ ──────────────────────────────────
if [[ -d "$DEBOLA_DIR/home" ]]; then
    log "Restoring hidden files from debola/home/..."
    for item in "$DEBOLA_DIR/home/".*; do
        name=$(basename "$item")
        target="$CURRENT_HOME/$name"
        if [[ -d "$item" ]]; then
            backup_and_copy_dir "$item" "$target"
        elif [[ -f "$item" ]]; then
            backup_and_copy "$item" "$target"
        fi
    done
    log "  Hidden files restored."
fi

# ── films.txt ─────────────────────────────────────────────────
if [[ -f "$DEBOLA_DIR/home/films.txt" ]]; then
    log "Restoring films.txt..."
    backup_and_copy "$DEBOLA_DIR/home/films.txt" "$CURRENT_HOME/films.txt"
fi

# ── Pictures/ ─────────────────────────────────────────────────
if [[ -d "$DEBOLA_DIR/Pictures" ]]; then
    log "Restoring Pictures/..."
    ensure_dir "$CURRENT_HOME/Pictures"
    for item in "$DEBOLA_DIR/Pictures/"*; do
        name=$(basename "$item")
        target="$CURRENT_HOME/Pictures/$name"
        if [[ -d "$item" ]]; then
            backup_and_copy_dir "$item" "$target"
        else
            backup_and_copy "$item" "$target"
        fi
    done
    log "  Pictures restored."
fi

# ── Zip backups ───────────────────────────────────────────────
zip_backups

log "Configuration restoration complete."
exit 0
