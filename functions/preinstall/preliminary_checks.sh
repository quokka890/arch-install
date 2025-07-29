#!/usr/bin/env bash
run_checks() {
local dir
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$dir/../../utils/logger.sh"
log "Verifying UEFI"
EFI_ARCH_FILE="/sys/firmware/efi/fw_platform_size"

if [[ ! -f "$EFI_ARCH_FILE" ]]; then
    error "System is not booted in UEFI mode. Aborting installation."
    exit 1
fi

EFI_ARCH=$(cat "$EFI_ARCH_FILE")
if [[ "$EFI_ARCH" != "64" ]]; then
    error "UEFI firmware is not 64-bit (found: $EFI_ARCH-bit). Aborting installation."
    exit 1
fi
success "UEFI verified"

log "Checking internet connectivity..."

if ping -q -c 1 -W 2 archlinux.org >/dev/null 2>&1; then
    success "Internet connection is active."
else
    error "No internet connection detected. Please connect and try again."
    exit 1
fi
success "Passed all preliminary checks"
}

