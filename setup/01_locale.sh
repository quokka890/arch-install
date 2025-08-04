#!/usr/bin/env bash
set -euo pipefail
configure_locale() {
    local dir
    dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$dir/../config/global.env"
    ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    hwclock --systohc
    sed -i "s/^# *$LOCALE/$LOCALE/" /etc/locale.gen
    locale-gen
    cat > /etc/locale.conf <<EOF
LANG=$LOCALE
EOF
    echo "KEYMAP=$KEYMAP" > /etc/vconsole.conf
    success "Locale, timezone, keymap and layout configured"
    LOCALE=true
}