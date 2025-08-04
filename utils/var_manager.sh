#!/usr/bin/env bash
update_env_var() {
    local root
    root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
    local key="$1"
    local value="$2"
    local original_caller="$3"
    local env_file="$root/config/global.env"
    local caller="${BASH_SOURCE[1]}"

    if [[ -z "$key" || -z "$value" ]]; then
        set -a
        # shellcheck disable=SC1091
        source "$root/config/global.env"
        set +a
        return
    fi


    if [[ -n "$original_caller" ]]; then
        caller="$original_caller"
    fi
    
    source "$root/utils/logger.sh"

    # If the key exists, replace it; otherwise, append it
    if grep -q "^${key}=" "$env_file"; then
        local old_value
        old_value="$(grep "^${key}=" "$env_file" | cut -d'=' -f2-)"
        sed -i "s|^${key}=.*|${key}=${value}|" "$env_file"
        log_env_change "$caller" "$key" "$old_value" "$value"
    else
        echo "${key}=${value}" >> "$env_file"
        log_env_change "$caller" "$key" "(unset)" "$value"
    fi

    set -a
    source "$root/config/global.env"
    set +a
}