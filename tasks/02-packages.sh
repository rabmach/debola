#!/usr/bin/env bash
### part of the DORiS suite of goodness - debian openbox restoration script(s) - 2026 machiner
# 02-packages.sh - Package installation
#

set -Euo pipefail
export DEBOLA_DIR="${DEBOLA_DIR:-$(cd "$(dirname "$0")/.." && pwd)}"
source "$DEBOLA_DIR/lib.sh"

header "PACKAGE INSTALLATION"

PACKAGES=(
    xorg x11-xserver-utils intel-microcode polkitd xinit
    intel-media-va-driver-non-free va-driver-all mesa-utils mesa-va-drivers
    dbus dbus-x11 pkexec mpg123 alsa-utils libnotify-bin
    notification-daemon smartmontools pulseaudio gvfs-backends arandr
    pnmixer mc lshw lsof ncal ncdu htop apt-utils at upower menu menu-xdg
    rsync fastfetch xscreensaver xscreensaver-gl xscreensaver-gl-extra
    fd-find libxml2-utils tar unzip zip pwgen usbutils yad bashtop grc
    duf xdg-user-dirs-gtk xdg-utils xdotool unzip usbutils util-linux
    imagemagick ips mpv net-tools xclip gsimplecal hwinfo iftop jpegoptim
    libimage-exiftool-perl zip silversearcher-ag galternatives sysstat
    vnstat xpdf fonts-jetbrains-mono acpi lm-sensors python3-pexpect pwgen
    sensible-utils iotop inxi psmisc s-tui sed dfc curl feh bat lsd nvtop
    unclutter numlockx wget whois bc jq tango-icon-theme obsidian-icon-theme
    arc-theme openbox pianobar orage gmrun gpicview gnome-characters
    obsession lxpanel engrampa thunar thunar-archive-plugin meld mintstick
    xfce4-clipman oxygencursors lxappearance papirus-icon-theme
    espeak mbrola mbrola-en1 redshift-gtk audacious libreoffice
    libreoffice-gtk3 murrine-themes lxappearance-obconf neverputt gparted
    ffmpeg scrot filezilla starship vym yelp zenity planner
    xfce4-screenshooter gimp bleachbit gifsicle synaptic geany
    geany-plugins ffmpegthumbnailer
)

log "Installing ${#PACKAGES[@]} packages..."
log "This may take a while. Download size is several gigabytes."

INSTALL_FAILED=false
if sudo apt-get install -y "${PACKAGES[@]}" 2>&1 | tee -a "$LOG_FILE"; then
    log "All packages installed successfully."
else
    warn "Some packages failed to install. Attempting individual fallback..."
    INSTALL_FAILED=true
fi

if $INSTALL_FAILED; then
    log "Retrying failed packages individually..."
    for pkg in "${PACKAGES[@]}"; do
        if ! is_installed "$pkg"; then
            log "  Installing $pkg..."
            if sudo apt-get install -y "$pkg" 2>&1 | tee -a "$LOG_FILE"; then
                log "  $pkg installed."
            else
                warn "  Failed to install $pkg. Skipping."
            fi
        fi
    done
fi

INSTALLED=$(dpkg -l 2>/dev/null | grep '^ii' | wc -l)
log "Total installed packages: $INSTALLED"
log "Package installation complete."
exit 0
