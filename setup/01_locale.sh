#!/usr/bin/env bash
set -eo pipefail
setup_locale() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../config/global.env"
    source "$dir/../utils/logger.sh"
    log "Setting up timezone and locale"
    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    hwclock --systohc
    sed -i "s/^# *$LOCALE/$LOCALE/" /etc/locale.gen
    locale-gen
    cat > /etc/locale.conf <<EOF
LANG=$LOCALE
EOF
    echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
    success "Locale, timezone, keymap and layout configured"
}