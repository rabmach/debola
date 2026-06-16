#!/usr/bin/env bash
### part of the DORiS suite of goodness - debian openbox restoration script(s) - 2026 machiner
# 00-check.sh - Prerequisites check
#

set -Euo pipefail
export DEBOLA_DIR="${DEBOLA_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$DEBOLA_DIR/lib.sh"

header "PREREQUISITES CHECK"

FAILED=0

if [[ $EUID -eq 0 ]]; then
    error "This script must NOT be run as root. Run it as your regular user."
    die "Please log in as your regular user and run ./restore.sh"
fi

log "Running as user: $CURRENT_USER (home: $CURRENT_HOME)"

if ! command -v sudo &>/dev/null; then
    warn "sudo not found. Attempting to install it..."
    if command -v apt-get &>/dev/null; then
        su -c "apt-get update && apt-get install -y sudo" || die "Failed to install sudo"
        log "sudo installed."
    else
        die "Cannot install sudo (apt-get not available). Install sudo manually first."
    fi
fi

log "sudo is available."

if ! sudo -n true 2>/dev/null; then
    warn "sudo requires a password for $CURRENT_USER."
    warn "Please ensure $CURRENT_USER is in the sudo group."
    warn "If not, as root run: usermod -aG sudo $CURRENT_USER"
    die "sudo access required."
fi

log "sudo access confirmed."

if ! command -v ping &>/dev/null; then
    warn "ping not found, will try wget/curl for network check."
fi

if command -v ping &>/dev/null; then
    if ping -c 1 -W 3 debian.org &>/dev/null || ping -c 1 -W 3 8.8.8.8 &>/dev/null; then
        log "Network connectivity confirmed."
    else
        warn "Network ping check failed. Continuing anyway (assuming network is available)."
    fi
fi

if [[ ! -d "$DEBOLA_DIR/config" ]]; then
    warn "Config directory not found at $DEBOLA_DIR/config"
    warn "Some restoration steps may be skipped."
fi

if [[ ! -d "$DEBOLA_DIR/home" ]]; then
    warn "Home backup directory not found at $DEBOLA_DIR/home"
fi

log "Prerequisites check passed."
exit 0
