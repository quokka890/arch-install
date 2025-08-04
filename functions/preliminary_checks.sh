#!/usr/bin/env bash
# shellcheck disable=SC1091
# shellcheck disable=SC2154
run_checks() {
    local root
    root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    source "$root/utils/logger.sh"
    status "Running preliminary checks"
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

    if ping -q -c 1 -W 2 archlinux.org >/dev/null 2>&1; then
        success "Internet connection is active."
    else
        error "No internet connection detected. Please connect and try again."
        exit 1
    fi
    success "Passed all preliminary checks"
}

