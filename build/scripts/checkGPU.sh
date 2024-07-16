#!/usr/bin/env bash

# Ensure working dir
#SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
#cd "$SCRIPT_DIR" || exit 1

# List all PCI devices and filter for GPU-related entries
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

# Classify GPU information
classify_gpus() {
    local gpu_info="$1"
    local amd_gpus=()
    local nvidia_gpus=()
    local intel_gpus=()

    # Arrays for specific combinations
    local amd_intel_prime=()
    local nvidia_intel_prime=()

    # Loop through each line of GPU info
    while IFS= read -r line; do
        printf "Processing line: %s\n" "$line" >&2

        case "$line" in
            *NVIDIA*)
                if [[ "$line" == *"Intel"* ]]; then
                    nvidia_intel_prime+=("$line")
                else
                    nvidia_gpus+=("$line")
                fi
                ;;
            *Intel*)
                if [[ "$line" == *"NVIDIA"* ]]; then
                    nvidia_intel_prime+=("$line")
                elif [[ "$line" == *"AMD"* || "$line" == *"ATI"* ]]; then
                    amd_intel_prime+=("$line")
                else
                    intel_gpus+=("$line")
                fi
                ;;
            *AMD*|*ATI*)
                amd_gpus+=("$line")
                ;;
            *)
                printf "Line did not match any known GPU vendors: %s\n" "$line" >&2
                ;;
        esac
    done <<< "$gpu_info"

    # Output the classified GPUs
    printf "Classified AMD GPUs:\n%s\n" "${amd_gpus[*]}" >&2
    printf "Classified NVIDIA GPUs:\n%s\n" "${nvidia_gpus[*]}" >&2
    printf "Classified Intel GPUs:\n%s\n" "${intel_gpus[*]}" >&2
    printf "Classified AMD-Intel Prime GPUs:\n%s\n" "${amd_intel_prime[*]}" >&2
    printf "Classified NVIDIA-Intel Prime GPUs:\n%s\n" "${nvidia_intel_prime[*]}" >&2

    # Determine which combination to use for updating .nix files
    if [[ ${#nvidia_intel_prime[@]} -gt 0 ]]; then
        printf "%s\n" "${nvidia_intel_prime[*]}"
    elif [[ ${#amd_intel_prime[@]} -gt 0 ]]; then
        printf "%s\n" "${amd_intel_prime[*]}"
    elif [[ ${#nvidia_gpus[@]} -gt 0 ]]; then
        printf "%s\n" "${nvidia_gpus[*]}"
    elif [[ ${#intel_gpus[@]} -gt 0 ]]; then
        printf "%s\n" "${intel_gpus[*]}"
    elif [[ ${#amd_gpus[@]} -gt 0 ]]; then
        printf "%s\n" "${amd_gpus[*]}"
    else
        printf "No known GPU types detected.\n" >&2
        exit 1
    fi
}

# Update .nix files with detected GPU information
update_nix_files() {
    local gpu="$1"
    shopt -s nullglob
    for nix_file in ./setups/*.nix; do
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

main() {
    local gpu_info
    if ! gpu_info=$(get_gpu_info); then
        exit 1
    fi

    printf "GPU(s) found on this system:\n%s\n" "$gpu_info"

    # Classify GPUs
    local classified_gpus
    classified_gpus=$(classify_gpus "$gpu_info")

    # Log classified GPUs
    printf "%s\n" "$classified_gpus"

    # Update .nix files based on detected GPUs
    if [[ "$classified_gpus" == *"NVIDIA-Intel Prime"* ]]; then
        update_nix_files "nvidiaIntelPrime"
    elif [[ "$classified_gpus" == *"AMD-Intel Prime"* ]]; then
        update_nix_files "amdIntelPrime"
    elif [[ "$classified_gpus" == *"NVIDIA"* ]]; then
        update_nix_files "nvidia"
    elif [[ "$classified_gpus" == *"Intel"* ]]; then
        update_nix_files "intel"
    elif [[ "$classified_gpus" == *"AMD"* ]]; then
        update_nix_files "amdgpu"
    else
        printf "No known GPU types detected.\n" >&2
        exit 1
    fi
}

main "$@"
