#!/usr/bin/env bash

valid_xkb_layouts=("us" "de" "fr" "es" "it" "gb" "jp" "ru")
default_xkb_layout="de"

valid_xkb_options=("eurosign:e" "compose:ralt" "ctrl:nocaps" "caps:swapescape" "altwin:swap_alt_win" "terminate:ctrl_alt_bksp")
default_xkb_options="eurosign:e"

# Function to handle script interruption
on_interrupt() {
    printf "Aborting the script.\n" >&2
    exit 0
}

# Trap SIGINT signal
trap 'on_interrupt' SIGINT

# Function to get GPU information
get_gpu_info() {
    local gpu_info
    gpu_info=$(lspci | grep -E 'VGA|3D|2D' | grep -i 'AMD\|ATI\|NVIDIA\|Intel')
    if [[ -z "$gpu_info" ]]; then
        printf "No GPU found on this system.\n" >&2
        return 1
    fi
    printf "%s\n" "$gpu_info"
    return 0
}

# Function to classify GPU information
classify_gpus() {
    local gpu_info="$1"
    local amd_gpus=()
    local nvidia_gpus=()
    local intel_gpus=()

    local amd_intel_prime=()
    local nvidia_intel_prime=()

    local has_nvidia=false
    local has_amd=false
    local has_intel=false

    while IFS= read -r line; do
        printf "Processing line: %s\n" "$line" >&2
        case "$line" in
            *NVIDIA*)
                has_nvidia=true
                nvidia_gpus+=("$line")
                ;;
            *Intel*)
                has_intel=true
                intel_gpus+=("$line")
                ;;
            *AMD*|*ATI*)
                has_amd=true
                amd_gpus+=("$line")
                ;;
            *)
                printf "Line did not match any known GPU vendors: %s\n" "$line" >&2
                ;;
        esac
    done <<< "$gpu_info"

    if $has_intel && $has_nvidia; then
        nvidia_intel_prime=("${nvidia_gpus[@]}" "${intel_gpus[@]}")
    fi

    if $has_intel && $has_amd; then
        amd_intel_prime=("${amd_gpus[@]}" "${intel_gpus[@]}")
    fi

    printf "Classified AMD GPUs:\n%s\n" "${amd_gpus[*]}" >&2
    printf "Classified NVIDIA GPUs:\n%s\n" "${nvidia_gpus[*]}" >&2
    printf "Classified Intel GPUs:\n%s\n" "${intel_gpus[*]}" >&2
    printf "Classified AMD-Intel Prime GPUs:\n%s\n" "${amd_intel_prime[*]}" >&2
    printf "Classified NVIDIA-Intel Prime GPUs:\n%s\n" "${nvidia_intel_prime[*]}" >&2

    if [[ ${#nvidia_intel_prime[@]} -gt 0 ]]; then
        printf "%s\n" "nvidiaIntelPrime"
    elif [[ ${#amd_intel_prime[@]} -gt 0 ]]; then
        printf "%s\n" "amdIntelPrime"
    elif [[ ${#nvidia_gpus[@]} -gt 0 ]]; then
        printf "%s\n" "nvidia"
    elif [[ ${#intel_gpus[@]} -gt 0 ]]; then
        printf "%s\n" "intel"
    elif [[ ${#amd_gpus[@]} -gt 0 ]]; then
        printf "%s\n" "amdgpu"
    else
        printf "No known GPU types detected.\n" >&2
        exit 1
    fi
}

# Function to update .nix files with detected GPU information
update_gpu_nix_files() {
    local gpu="$1"
    shopt -s nullglob
    for nix_file in ./build/setups/*.nix; do
        if [[ -f "$nix_file" ]]; then
            sed -i -e "s/gpu = \".*\"/gpu = \"$gpu\"/" "$nix_file"
            if [[ $? -eq 0 ]]; then
                printf "Updated %s with detected GPU information.\n" "$nix_file" >&2
            else
                printf "Failed to update %s.\n" "$nix_file" >&2
            fi
        fi
    done
}

# Function to get LANG setting from environment
get_lang_setting() {
    local lang
    lang=$(printf '%s' "$LANG")
    printf "%s\n" "$lang"
}

# Function to get XKB layout from NixOS configuration files
get_xkb_layout() {
    local xkb_layout
    xkb_layout=$(grep -rPo '(?<=services\.xserver\.xkb\.layout = ")[^"]*(?=")' /etc/nixos | cut -d':' -f2)
    if [[ -z "$xkb_layout" || "$xkb_layout" == "env.keyboardLayout" || ! " ${valid_xkb_layouts[@]} " =~ " $xkb_layout " ]]; then
        xkb_layout="$default_xkb_layout"
    fi
    printf "%s\n" "$xkb_layout"
}

# Function to get XKB options from NixOS configuration files
get_xkb_options() {
    local xkb_options
    xkb_options=$(grep -rPo '(?<=services\.xserver\.xkb\.options = ")[^"]*(?=")' /etc/nixos | cut -d':' -f2)
    if [[ -z "$xkb_options" || "$xkb_options" == "env.keyboardOptions" || ! " ${valid_xkb_options[@]} " =~ " $xkb_options " ]]; then
        xkb_options="$default_xkb_options"
    fi
    printf "%s\n" "$xkb_options"
}

# Function to get console keymap from NixOS configuration files
get_console_keymap() {
    local console_keymap
    console_keymap=$(grep -rPo '(?<=console\.keyMap = ")[^"]*(?=")' /etc/nixos)
    if [[ -z "$console_keymap" && -f /etc/vconsole.conf ]]; then
        console_keymap=$(grep 'KEYMAP' /etc/vconsole.conf | awk -F= '{print $2}')
    fi
    if [[ -z "$console_keymap" ]]; then
        console_keymap="us"
    fi
    printf "%s\n" "$console_keymap"
}

# Function to update NixOS configuration files
update_locale_nix_files() {
    local lang="$1"
    local xkb_layout="$2"
    local xkb_options="$3"
    local console_keymap="$4"

    for nix_file in ./build/setups/*.nix; do
        if [[ -f "$nix_file" ]]; then
            printf "Updating file: %s\n" "$nix_file"

            if grep -q 'locales = \[' "$nix_file"; then
                sed -i -e "s/locales = \[.*\];/locales = \[ \"$lang\" \];/" "$nix_file"
            else
                sed -i -e "s/locales = .*/locales = \[ \"$lang\" \];/" "$nix_file"
            fi

            if [[ -n "$xkb_layout" ]]; then
                if grep -q 'keyboardLayout =' "$nix_file"; then
                    sed -i -e "s/keyboardLayout = \".*\";/keyboardLayout = \"$xkb_layout\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardLayout = .*/keyboardLayout = \"$xkb_layout\";/" "$nix_file"
                fi
            elif [[ -n "$console_keymap" ]]; then
                if grep -q 'keyboardLayout =' "$nix_file"; then
                    sed -i -e "s/keyboardLayout = \".*\";/keyboardLayout = \"$console_keymap\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardLayout = .*/keyboardLayout = \"$console_keymap\";/" "$nix_file"
                fi
            else
                if grep -q 'keyboardLayout =' "$nix_file"; then
                    sed -i -e "s/keyboardLayout = \".*\";/keyboardLayout = \"us\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardLayout = .*/keyboardLayout = \"us\";/" "$nix_file"
                fi
            fi

            if [[ -n "$xkb_options" ]]; then
                if grep -q 'keyboardOptions =' "$nix_file"; then
                    sed -i -e "s/keyboardOptions = \".*\";/keyboardOptions = \"$xkb_options\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardOptions = .*/keyboardOptions = \"$xkb_options\";/" "$nix_file"
                fi
            else
                if grep -q 'keyboardOptions =' "$nix_file"; then
                    sed -i -e "s/keyboardOptions = \".*\";/keyboardOptions = \"\";/" "$nix_file"
                else
                    sed -i -e "s/keyboardOptions = .*/keyboardOptions = \"\";/" "$nix_file"
                fi
            fi
        fi
    done
}

# Function to get the current system's username
get_username() {
    local username
    username=$(whoami)
    if [[ -z "$username" ]]; then
        printf "Failed to get the username.\n" >&2
        return 1
    fi
    printf "%s" "$username"
}

# Function to get the current system's hostname
get_hostname() {
    local hostname
    hostname=$(hostname)
    if [[ -z "$hostname" ]]; then
        printf "Failed to get the hostname.\n" >&2
        return 1
    fi
    printf "%s" "$hostname"
}

# Function to update .nix files with detected username and hostname information
update_user_host_nix_files() {
    local username="$1"
    local hostname="$2"
    shopt -s nullglob
    for nix_file in ./build/setups/*.nix; do
        if [[ -f "$nix_file" ]]; then
            sed -i -e "s/mainUser = \".*\"/mainUser = \"$username\"/" \
                   -e "s/hostName = \".*\"/hostName = \"$hostname\"/" "$nix_file"
            if [[ $? -eq 0 ]]; then
                printf "Updated %s with detected username and hostname information.\n" "$nix_file" >&2
            else
                printf "Failed to update %s.\n" "$nix_file" >&2
            fi
        fi
    done
}

main() {
    # GPU information
    local gpu_info
    if ! gpu_info=$(get_gpu_info); then
        exit 1
    fi
    printf "GPU(s) found on this system:\n%s\n" "$gpu_info"
    local classified_gpus
    classified_gpus=$(classify_gpus "$gpu_info")
    printf "%s\n" "$classified_gpus"
    update_gpu_nix_files "$classified_gpus"

    # Locale information
    local lang xkb_layout xkb_options console_keymap
    lang=$(get_lang_setting)
    xkb_layout=$(get_xkb_layout)
    xkb_options=$(get_xkb_options)
    console_keymap=$(get_console_keymap)
    update_locale_nix_files "$lang" "$xkb_layout" "$xkb_options" "$console_keymap"
    printf "Settings updated in NixOS configuration files.\n"
    printf "lang: %s\nxkb_layout: %s\nxkb_options: %s\nconsole_keymap: %s\n" "$lang" "$xkb_layout" "$xkb_options" "$console_keymap"

    # Username and Hostname
    local username hostname
    if ! username=$(get_username); then
        exit 1
    fi
    if ! hostname=$(get_hostname); then
        exit 1
    fi
    update_user_host_nix_files "$username" "$hostname"
}

main "$@"
