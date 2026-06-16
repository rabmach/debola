#!/usr/bin/env bash
### part of the DORiS suite of goodness - debian openbox restoration script(s) - 2026 machiner
# lib.sh - Shared library for debola restoration
#

export DEBOLA_DIR="${DEBOLA_DIR:-$HOME/debola}"
export LOG_FILE="$DEBOLA_DIR/restore.log"
export ERROR_FILE="$DEBOLA_DIR/restore-errors.log"
export STATUS_FILE="$DEBOLA_DIR/.task_status"
export BACKUP_BASE="$DEBOLA_DIR/backups"
export CURRENT_USER="${SUDO_USER:-$(whoami)}"
export CURRENT_HOME
CURRENT_HOME="$(eval echo "~$CURRENT_USER")"
export BACKUP_DIR="$BACKUP_BASE/$(date +%Y%m%d-%H%M%S)"

mkdir -p "$(dirname "$LOG_FILE")" "$BACKUP_BASE"

log()  { echo "[$(date '+%H:%M:%S')]  $*" | tee -a "$LOG_FILE"; }
info() { echo "  -> $*" | tee -a "$LOG_FILE"; }
warn() { echo "  [WARN] $*" | tee -a "$LOG_FILE"; echo "[WARN] $*" >> "$ERROR_FILE"; }
error(){ echo "  [ERROR] $*" | tee -a "$LOG_FILE" >&2; echo "[ERROR] $*" >> "$ERROR_FILE"; }
die()  { error "$*"; exit 1; }

header() {
    echo "" | tee -a "$LOG_FILE"
    echo "==============================================" | tee -a "$LOG_FILE"
    echo "  $*" | tee -a "$LOG_FILE"
    echo "==============================================" | tee -a "$LOG_FILE"
    echo "" | tee -a "$LOG_FILE"
}

backup_file() {
    local target="$1"
    if [[ -e "$target" ]]; then
        local rel="${target#/}"
        local dest="$BACKUP_DIR/$rel"
        mkdir -p "$(dirname "$dest")"
        cp -a "$target" "$dest"
        log "  Backed up: $target"
        return 0
    fi
    return 1
}

backup_and_copy() {
    local src="$1" dest="$2"
    if [[ -e "$dest" ]]; then
        backup_file "$dest"
    fi
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
}

backup_and_copy_dir() {
    local src="$1" dest="$2"
    if [[ -d "$dest" ]]; then
        backup_file "$dest"
    fi
    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
}

zip_backups() {
    if [[ -d "$BACKUP_DIR" ]] && [[ -n "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]]; then
        info "Creating backup archive..."
        (cd "$BACKUP_BASE" && tar czf "$(basename "$BACKUP_DIR").tar.gz" "$(basename "$BACKUP_DIR")" 2>/dev/null && rm -rf "$BACKUP_DIR")
        log "  Backup archived: $BACKUP_DIR.tar.gz"
    fi
}

replace_user() {
    local file="$1"
    if [[ -f "$file" ]]; then
        sed -i "s/\$USER/$CURRENT_USER/g" "$file"
        log "  Replaced \$USER in: $file"
    fi
}

is_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q '^ii'
}

ensure_dir() {
    mkdir -p "$1"
}

sudo_exec() {
    if [[ -n "${SUDO_PASS:-}" ]]; then
        echo "$SUDO_PASS" | sudo -S "$@" 2>/dev/null
    else
        sudo "$@"
    fi
}
