#!/usr/bin/env bash
### part of the DORiS suite of goodness - debian openbox restoration script(s) - 2026 machiner
# 06-finish.sh - Optional packages, monitor setup, and completion
#

set -Euo pipefail
export DEBOLA_DIR="${DEBOLA_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$DEBOLA_DIR/lib.sh"

header "OPTIONAL PACKAGES"

OPTIONAL_PACKAGES=()

# In first-boot mode, skip interactive prompts and install defaults
if [[ "${FIRST_BOOT:-false}" == "true" ]]; then
    log "First-boot mode: Installing default optional packages..."
    OPTIONAL_PACKAGES=(firefox keepassxc alacritty)
else
    echo ""
    echo "  Would you like to install a web browser (Firefox)? [y/N]"
    read -r REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        OPTIONAL_PACKAGES+=(firefox)
    fi

    echo ""
    echo "  Would you like to install email support (Claws Mail)? [y/N]"
    read -r REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        OPTIONAL_PACKAGES+=(claws-mail claws-mail-bogofilter claws-mail-fancy-plugin
            claws-mail-pgpmime claws-mail-tools claws-mail-pgpinline
            claws-mail-vcalendar-plugin bogofilter lynx)
    fi

    echo ""
    echo "  Would you like to install a password manager (KeePassXC)? [y/N]"
    read -r REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        OPTIONAL_PACKAGES+=(keepassxc)
    fi

    echo ""
    echo "  Which terminal would you like to install?"
    echo "    1) Alacritty"
    echo "    2) Kitty"
    echo "    3) None"
    read -r REPLY
    case "$REPLY" in
        1) OPTIONAL_PACKAGES+=(alacritty) ;;
        2) OPTIONAL_PACKAGES+=(kitty) ;;
    esac

    echo ""
    echo "  Would you like to install printing support (CUPS)? [y/N]"
    read -r REPLY
    if [[ "$REPLY" =~ ^[Yy]$ ]]; then
        OPTIONAL_PACKAGES+=(cups system-config-printer)
    fi
fi

if [[ ${#OPTIONAL_PACKAGES[@]} -gt 0 ]]; then
    log "Installing optional packages: ${OPTIONAL_PACKAGES[*]}"
    if sudo apt-get install -y "${OPTIONAL_PACKAGES[@]}" 2>&1 | tee -a "$LOG_FILE"; then
        log "Optional packages installed."
    else
        warn "Some optional packages failed to install."
    fi
else
    log "No optional packages selected."
fi

# ── Set alternatives for newly installed packages ───────────
if [[ -x /usr/bin/alacritty ]]; then
    log "  Setting x-terminal-emulator → alacritty..."
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 210 2>&1 | tee -a "$LOG_FILE"
fi

if [[ -x /usr/bin/subl ]]; then
    log "  Setting x-text-editor → subl..."
    sudo update-alternatives --install /usr/bin/x-text-editor x-text-editor /usr/bin/subl 210 2>&1 | tee -a "$LOG_FILE"
fi

if [[ -x /usr/bin/kitty ]]; then
    log "  Setting x-terminal-emulator → kitty..."
    sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/kitty 200 2>&1 | tee -a "$LOG_FILE"
fi

header "EXTERNAL MONITOR SETUP"

AUTOSTART_FILE="$CURRENT_HOME/.config/openbox/autostart"
MONITOR_DEFAULT="true"

if [[ "${FIRST_BOOT:-false}" == "true" ]]; then
    log "First-boot mode: Skipping external monitor setup."
else
    if [[ -d "$CURRENT_HOME/.screenlayout" ]]; then
        echo ""
        echo "  Would you like to default to an external monitor on boot? [Y/n]"
        read -r REPLY
        if [[ "$REPLY" =~ ^[Nn]$ ]]; then
            MONITOR_DEFAULT="false"
        fi
    fi
fi

if [[ "$MONITOR_DEFAULT" == "false" ]] && [[ -f "$AUTOSTART_FILE" ]]; then
    if grep -q '^\[ -d ~/.screenlayout \]' "$AUTOSTART_FILE"; then
        sed -i 's|^\(\[ -d ~/.screenlayout \]\)|#\1|' "$AUTOSTART_FILE"
        log "Disabled external monitor default in autostart."
    fi
elif [[ "$MONITOR_DEFAULT" == "true" ]] && [[ -f "$AUTOSTART_FILE" ]]; then
    if grep -q '^#\[ -d ~/.screenlayout \]' "$AUTOSTART_FILE"; then
        sed -i 's|^#\[ -d ~/.screenlayout \]|[ -d ~/.screenlayout ]|' "$AUTOSTART_FILE"
        log "Enabled external monitor default in autostart."
    fi
fi

header "RESTORATION COMPLETE"

ERROR_COUNT=0
WARN_COUNT=0

if [[ -f "$ERROR_FILE" ]]; then
    ERROR_COUNT=$(grep -c '^\[ERROR\]' "$ERROR_FILE" 2>/dev/null || echo 0)
    WARN_COUNT=$(grep -c '^\[WARN\]' "$ERROR_FILE" 2>/dev/null || echo 0)
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
