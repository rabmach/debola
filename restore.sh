#!/usr/bin/env bash
### this here starts the work - quick and handy DORiS for the debola - machiner 2026
### have at it
# restore.sh - Debian Openbox Restoration Script
#
# A robust, safe, and efficient script for reproducing a custom Debian
# Linux installation using the Openbox window manager.
#
# Usage:
#   ./restore.sh                    # Run full restoration
#   ./restore.sh --help             # Show help
#   ./restore.sh --skip 01         # Skip a specific task (by number)
#   ./restore.sh --only 04         # Run only a specific task
#   ./restore.sh --list            # List available tasks
#   ./restore.sh --dry-run         # Show what would be done without doing it
#   ./restore.sh --first-boot      # First-boot mode (used by debola-first-boot.service)
#

set -Euo pipefail

export DEBOLA_DIR
DEBOLA_DIR="$(cd "$(dirname "$0")" && pwd)"
export LOG_FILE="$DEBOLA_DIR/restore.log"
export ERROR_FILE="$DEBOLA_DIR/restore-errors.log"
export STATUS_FILE="$DEBOLA_DIR/.task_status"
export BACKUP_BASE="$DEBOLA_DIR/backups"
export CURRENT_USER="${SUDO_USER:-$(whoami)}"
export CURRENT_HOME
CURRENT_HOME="$(eval echo "~$CURRENT_USER")"

source "$DEBOLA_DIR/lib.sh"

# ── Parse arguments ──────────────────────────────────────────────
SKIP_TASKS=()
ONLY_TASK=""
DRY_RUN=false
FIRST_BOOT=false

usage() {
    echo "Usage: $(basename "$0") [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --help         Show this help message"
    echo "  --list         List available tasks"
    echo "  --skip NUM     Skip a task (can be used multiple times)"
    echo "  --only NUM     Run only a single task"
    echo "  --dry-run      Show what would be done without executing"
    echo "  --first-boot   First-boot mode (non-interactive, used by systemd service)"
    echo ""
    echo "Tasks:"
    for task in "$DEBOLA_DIR/tasks/"*.sh; do
        name=$(basename "$task" .sh)
        desc=$(head -3 "$task" | grep -E '^#' | tail -1 | sed 's/^# *//')
        echo "  $name   $desc"
    done
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help) usage ;;
        --list) usage ;;
        --skip) shift; SKIP_TASKS+=("$1"); shift ;;
        --only) shift; ONLY_TASK="$1"; shift ;;
        --dry-run) DRY_RUN=true; shift ;;
        --first-boot) FIRST_BOOT=true; shift ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# ── Clean up status file ─────────────────────────────────────────
rm -f "$STATUS_FILE"
: > "$LOG_FILE"
: > "$ERROR_FILE"

# ── Header ───────────────────────────────────────────────────────
cat << "EOF"

  ____                         _           _  ___ 
 / ___|  __ _ _   _  __      _| |__   __ _| ||__ \
 \___ \ / _` | | | | \ \ /\ / / '_ \ / _` | __|/ /
  ___) | (_| | |_| |  \ V  V /| | | | (_| | |_|_| 
 |____/ \__,_|\__, |   \_/\_/ |_| |_|\__,_|\__(_) 
              |___/  

  Debian Openbox Restoration Script - DORiS
=====================================================
EOF

log "Starting debola restoration..."
log "User: $CURRENT_USER"
log "Home: $CURRENT_HOME"
log "Date: $(date)"

if $DRY_RUN; then
    info "DRY RUN MODE - No changes will be made"
fi

if $FIRST_BOOT; then
    info "FIRST BOOT MODE - Non-interactive restoration"
fi

# ── Run tasks ────────────────────────────────────────────────────
TASKS_DIR="$DEBOLA_DIR/tasks"
TOTAL=0
PASSED=0
FAILED_LIST=()

export FIRST_BOOT

for task in "$TASKS_DIR/"*.sh; do
    task_name=$(basename "$task" .sh)
    task_num="${task_name%%-*}"

    if [[ -n "$ONLY_TASK" ]] && [[ "$task_num" != "$ONLY_TASK" ]]; then
        continue
    fi
    for skip in "${SKIP_TASKS[@]}"; do
        if [[ "$task_num" == "$skip" ]]; then
            log "Skipping task $task_name (--skip $skip)"
            continue 2
        fi
    done

    ((TOTAL++))
    header "TASK $task_name"

    if $DRY_RUN; then
        desc=$(sed -n '3p' "$task" | sed 's/^# //')
        info "[DRY-RUN] Would run: $desc"
        continue
    fi

    if bash "$task"; then
        log "  TASK $task_name completed successfully."
        ((PASSED++))
    else
        error "  TASK $task_name FAILED."
        FAILED_LIST+=("$task_name")
    fi
done

# ── Final summary ────────────────────────────────────────────────
if ! $DRY_RUN; then
    echo ""
    echo "=============================================="
    echo "  RESTORATION SUMMARY"
    echo "=============================================="
    echo "  Total tasks:  $TOTAL"
    echo "  Passed:       $PASSED"
    if [[ ${#FAILED_LIST[@]} -gt 0 ]]; then
        echo "  Failed:       ${#FAILED_LIST[@]}"
        for f in "${FAILED_LIST[@]}"; do
            echo "    - $f"
        done
    fi

    ERROR_COUNT=$(grep -c '^\[ERROR\]' "$ERROR_FILE" 2>/dev/null || echo 0)
    WARN_COUNT=$(grep -c '^\[WARN\]' "$ERROR_FILE" 2>/dev/null || echo 0)
    echo "  Errors:       $ERROR_COUNT"
    echo "  Warnings:     $WARN_COUNT"

    if [[ -f "$STATUS_FILE" ]] && grep -q "ICON_FAILURE=1" "$STATUS_FILE" 2>/dev/null; then
        echo ""
        echo "  [NOTE] Icon theme download/extraction had issues."
        echo "         You may need to manually install Dracula and/or Kora icons."
    fi

    if ls "$BACKUP_BASE/"*.tar.gz 2>/dev/null | head -1 >/dev/null 2>&1; then
        BACKUP_FILE=$(ls -t "$BACKUP_BASE/"*.tar.gz 2>/dev/null | head -1)
        echo ""
        echo "  Backup archive: $BACKUP_FILE"
    fi

    echo ""
    echo "  Log file:  $LOG_FILE"
    echo "  Errors:    $ERROR_FILE"
    echo ""
    echo "  Recommended: Reboot to load new kernel (if XanMod was installed)."
    echo "               Then run 'startx' to launch Openbox."
    echo ""

    if [[ ${#FAILED_LIST[@]} -gt 0 ]]; then
        exit 1
    fi
fi

exit 0
