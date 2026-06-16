#!/usr/bin/env bash
### part of the DORiS suite of goodness - debian openbox restoration script(s) - 2026 machiner
# 06-finish.sh - Summary and completion
#

set -Euo pipefail
export DEBOLA_DIR="${DEBOLA_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$DEBOLA_DIR/lib.sh"

header "RESTORATION SUMMARY"

ERROR_COUNT=0
WARN_COUNT=0

if [[ -f "$ERROR_FILE" ]]; then
    ERROR_COUNT=$(grep -c '^\[ERROR\]' "$ERROR_FILE" 2>/dev/null || echo 0)
    WARN_COUNT=$(grep -c '^\[WARN\]' "$ERROR_FILE" 2>/dev/null || echo 0)
fi

log "  Errors:   $ERROR_COUNT"
log "  Warnings: $WARN_COUNT"

ICON_FAILURE=false
if [[ -f "$STATUS_FILE" ]] && grep -q "ICON_FAILURE=1" "$STATUS_FILE" 2>/dev/null; then
    ICON_FAILURE=true
fi

echo ""
echo "----------------------------------------------"
echo "  DEBOLA RESTORATION COMPLETE"
echo "----------------------------------------------"
echo ""
echo "  Log file:        $LOG_FILE"
echo "  Error log:       $ERROR_FILE"

if ls "$BACKUP_BASE/"*.tar.gz 2>/dev/null; then
    BACKUP_FILE=$(ls -t "$BACKUP_BASE/"*.tar.gz 2>/dev/null | head -1)
    echo "  Backup archive:  $BACKUP_FILE"
fi

echo ""

if $ICON_FAILURE; then
    echo "  [NOTE] Some icon themes failed to install."
    echo "         You may need to download and install them manually."
    echo "         See the log for details."
    echo ""
fi

if [[ $ERROR_COUNT -gt 0 ]] || [[ $WARN_COUNT -gt 0 ]]; then
    echo "  Some issues were encountered (see $ERROR_FILE for details)."
    echo ""
fi

echo "  Recommended next steps:"
echo "    1. Reboot to load the new kernel (if XanMod was installed)"
echo "    2. Run 'startx' to start Openbox"
echo "    3. Configure appearance with lxappearance"
echo "    4. Check $ERROR_FILE if anything seems missing"
echo ""

exit 0
