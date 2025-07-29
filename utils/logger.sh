#!/usr/bin/env bash
RESET="\e[0m"
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
CYAN="\e[1;36m"

timestamp() {
    date +"%Y-%m-%d %H:%M:%S"
}

log() {
    local message="$1"
    local confirm_flag="$2"

    echo -e "${CYAN}[$(timestamp)] [INFO]${RESET} $message"

    if [[ "$confirm_flag" == "confirm" ]]; then
        local prompt
        local response
        local default_response="Y"
        prompt="${RED}Are you sure you want to proceed? Y/n${RESET} "

        read -p -r "$(echo -e "$prompt")" response
        response=${response:-$default_response}

        if ! [[ $response =~ ^[Yy]$ ]]; then
            warn "Operation aborted by user."
            exit 1
        fi
    fi
}

warn() {
    echo -e "${YELLOW}[$(timestamp)] [WARN]${RESET} $*" >&2
}

error() {
    echo -e "${RED}[$(timestamp)] [ERROR]${RESET} $*" >&2
}

success() {
    echo -e "${GREEN}[$(timestamp)] [ OK ]${RESET} $*"
}

debug() {
    if [[ "${DEBUG:-0}" == "1" ]]; then
        echo -e "${BLUE}[$(timestamp)] [DEBUG]${RESET} $*"
    fi
}
