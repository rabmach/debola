#!/usr/bin/env bash
### part of the DORiS suite of goodness - debian openbox restoration script(s) - 2026 machiner
# 05-tweaks.sh - Post-installation system tweaks
#

set -Euo pipefail
export DEBOLA_DIR="${DEBOLA_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$DEBOLA_DIR/lib.sh"

header "POST-INSTALLATION SYSTEM TWEAKS"

# ── Pianobar script permissions ───────────────────────────────
PIANOBAR_SCRIPTS=(
    "$CURRENT_HOME/.config/pianobar/control-pianobar.sh"
    "$CURRENT_HOME/.config/pianobar/pianobar-notify.sh"
)
for script in "${PIANOBAR_SCRIPTS[@]}"; do
    if [[ -f "$script" ]]; then
        chmod +x "$script"
        log "  Made executable: $script"
    else
        warn "  Script not found: $script"
    fi
done

# ── Notification daemon autostart ────────────────────────────
NOTIFY_DESKTOP="/usr/share/applications/notification-daemon.desktop"
if [[ -f "$NOTIFY_DESKTOP" ]]; then
    sudo cp "$NOTIFY_DESKTOP" /etc/xdg/autostart/
    sudo chmod +x /etc/xdg/autostart/notification-daemon.desktop
    log "  notification-daemon autostart configured."
else
    warn "  notification-daemon.desktop not found at $NOTIFY_DESKTOP"
fi

# ── Update alternatives ───────────────────────────────────────
log "  Setting x-file-manager → thunar..."
sudo update-alternatives --install /usr/bin/x-file-manager x-file-manager /usr/bin/thunar 230 2>&1 | tee -a "$LOG_FILE"

if [[ -x /usr/bin/alacritty ]]; then
    log "  Setting x-terminal-emulator → alacritty..."
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 210 2>&1 | tee -a "$LOG_FILE"
else
    warn "  alacritty not found, skipping x-terminal-emulator alternative."
fi

if [[ -x /usr/bin/subl ]]; then
    log "  Setting x-text-editor → subl..."
    sudo update-alternatives --install /usr/bin/x-text-editor x-text-editor /usr/bin/subl 210 2>&1 | tee -a "$LOG_FILE"
else
    warn "  subl not found, skipping x-text-editor alternative."
fi

# ── Remove xdg-desktop-portal ─────────────────────────────────
log "  Removing xdg-desktop-portal packages..."
if sudo apt-get remove -y xdg-desktop-portal xdg-desktop-portal-gtk 2>&1 | tee -a "$LOG_FILE"; then
    log "  xdg-desktop-portal packages removed."
else
    warn "  Failed to remove xdg-desktop-portal packages (may not be installed)."
fi

log "Post-installation tweaks complete."
exit 0
