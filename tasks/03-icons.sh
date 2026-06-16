#!/usr/bin/env bash
### part of the DORiS suite of goodness - debian openbox restoration script(s) - 2026 machiner
# 03-icons.sh - Icon theme installation
#

set -Euo pipefail
export DEBOLA_DIR="${DEBOLA_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$DEBOLA_DIR/lib.sh"

header "ICON THEME INSTALLATION"

ICON_ERRORS=false
DL_DIR="/tmp/debola-downloads"
mkdir -p "$DL_DIR" "$CURRENT_HOME/Downloads"

log "Downloading Dracula icon theme..."
if wget -q --show-progress -O "$DL_DIR/Dracula.zip" \
    "https://github.com/dracula/gtk/files/5214870/Dracula.zip" 2>&1; then
    log "Dracula.zip downloaded."

    if unzip -o "$DL_DIR/Dracula.zip" -d "$DL_DIR/dracula-extract" 2>&1 | tee -a "$LOG_FILE"; then
        log "Dracula.zip extracted."
        if [[ -d "$DL_DIR/dracula-extract/Dracula" ]]; then
            sudo cp -R "$DL_DIR/dracula-extract/Dracula" /usr/share/icons/
            log "Dracula icons installed to /usr/share/icons/."
        else
            warn "Dracula directory not found after extraction."
            ICON_ERRORS=true
        fi
    else
        warn "Failed to extract Dracula.zip."
        ICON_ERRORS=true
    fi
else
    warn "Failed to download Dracula icon theme."
    ICON_ERRORS=true
fi

log "Downloading Kora icon theme..."
if wget -q --show-progress -O "$DL_DIR/kora-master.zip" \
    "https://github.com/bikass/kora/archive/refs/heads/master.zip" 2>&1; then
    log "kora-master.zip downloaded."

    if unzip -o "$DL_DIR/kora-master.zip" -d "$DL_DIR/kora-extract" 2>&1 | tee -a "$LOG_FILE"; then
        log "kora-master.zip extracted."
        if [[ -d "$DL_DIR/kora-extract/kora-master/kora" ]]; then
            ensure_dir "$CURRENT_HOME/.local/share/icons"
            cp -R "$DL_DIR/kora-extract/kora-master/kora" "$CURRENT_HOME/.local/share/icons/"
            log "Kora icons installed to ~/.local/share/icons/."
        else
            warn "kora directory not found after extraction."
            ICON_ERRORS=true
        fi
    else
        warn "Failed to extract kora-master.zip. Skipping (non-fatal)."
        ICON_ERRORS=true
    fi
else
    warn "Failed to download Kora icon theme."
    ICON_ERRORS=true
fi

rm -rf "$DL_DIR"

if $ICON_ERRORS; then
    echo "ICON_FAILURE=1" >> "$STATUS_FILE"
    warn "Some icon themes failed to install. Check log for details."
else
    log "All icon themes installed successfully."
fi

log "Icon theme installation complete."
exit 0
