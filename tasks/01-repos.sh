#!/usr/bin/env bash
### part of the DORiS suite of goodness - debian openbox restoration script(s) - 2026 machiner
# 01-repos.sh - External repository setup
#

set -Euo pipefail
export DEBOLA_DIR="${DEBOLA_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$DEBOLA_DIR/lib.sh"

header "EXTERNAL REPOSITORIES"

sudo mkdir -p /etc/apt/keyrings

if [[ ! -f /etc/apt/sources.list.d/sublime-text.sources ]]; then
    log "Adding Sublime Text repository..."
    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg \
        | sudo tee /etc/apt/keyrings/sublimehq-pub.asc > /dev/null
    echo -e 'Types: deb\nURIs: https://download.sublimetext.com/\nSuites: apt/stable/\nSigned-By: /etc/apt/keyrings/sublimehq-pub.asc' \
        | sudo tee /etc/apt/sources.list.d/sublime-text.sources > /dev/null
    log "Sublime Text repository added."
else
    log "Sublime repository already exists. Skipping."
fi

if [[ ! -f /etc/apt/sources.list.d/mozilla.list ]]; then
    log "Adding Mozilla repository..."
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- \
        | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
        | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
    log "Mozilla repository added."
else
    log "Mozilla repository already exists. Skipping."
fi

if [[ ! -f /etc/apt/preferences.d/mozilla ]]; then
    log "Adding Mozilla package pinning..."
    sudo tee /etc/apt/preferences.d/mozilla > /dev/null <<'EOF'
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF
    log "Mozilla package pinning added."
else
    log "Mozilla pinning already exists. Skipping."
fi

##if [[ ! -f /etc/apt/sources.list.d/xanmod-release.sources ]]; then
##    log "Adding XanMod repository..."
##    wget -qO- https://dl.xanmod.org/archive.key \
##        | sudo gpg --dearmor --yes -o /usr/share/keyrings/xanmod-archive-keyring.gpg 2>/dev/null
##    if [[ -f /etc/os-release ]]; then
##        . /etc/os-release
##        printf '%s\n' \
##            "Types: deb" \
##            "URIs: https://deb.xanmod.org" \
##            "Suites: $VERSION_CODENAME" \
##            "Components: main" \
##            "Signed-By: /usr/share/keyrings/xanmod-archive-keyring.gpg" \
##            | sudo tee /etc/apt/sources.list.d/xanmod-release.sources > /dev/null
##        log "XanMod repository added (suite: $VERSION_CODENAME)."
##    else
##        warn "/etc/os-release not found. XanMod repository not added."
##    fi
##else
##    log "XanMod repository already exists. Skipping."
##fi

log "Updating apt package lists..."
if sudo apt-get update 2>&1 | tee -a "$LOG_FILE"; then
    log "Package lists updated."
else
    warn "apt update had non-fatal errors. Continuing..."
fi

log "Repository setup complete."
exit 0
