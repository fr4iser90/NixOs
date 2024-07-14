#!/usr/bin/env bash

# Ensure pciutils (lspci) is installed
if ! command -v lspci > /dev/null; then
    printf "pciutils (lspci) is not installed. Installing pciutils...\n" >&2
    nix-env -iA nixos.pciutils

    # Check if installation was successful
    if ! command -v lspci > /dev/null; then
        printf "Failed to install pciutils. Please install it manually using your package manager.\n" >&2
        exit 1
    fi
fi

# Check if grep is installed
if ! command -v grep > /dev/null; then
    printf "grep is not installed. Please install it using your package manager.\n" >&2
    exit 1
fi

# List all PCI devices and filter for GPU-related entries
gpu_info=$(lspci | grep -i 'vga\|3d\|2d')

# Check if any GPU information was found
if [[ -z "$gpu_info" ]]; then
    printf "No GPU found on this system.\n" >&2
    exit 1
fi

# Initialize variables to store GPU information
amd_gpus=""
nvidia_gpus=""
intel_gpus=""

# Process each line of the GPU info
while IFS= read -r line; do
    if printf "%s\n" "$line" | grep -qi 'AMD\|ATI'; then
        amd_gpus+="$line\n"
    elif printf "%s\n" "$line" | grep -qi 'NVIDIA'; then
        nvidia_gpus+="$line\n"
    elif printf "%s\n" "$line" | grep -qi 'Intel'; then
        intel_gpus+="$line\n"
    fi
done <<< "$gpu_info"

# Print the GPU information
printf "GPU(s) found on this system:\n"

if [[ -n "$amd_gpus" ]]; then
    printf "AMD GPU(s):\n%s" "$amd_gpus"
fi

if [[ -n "$nvidia_gpus" ]]; then
    printf "NVIDIA GPU(s):\n%s" "$nvidia_gpus"
fi

if [[ -n "$intel_gpus" ]]; then
    printf "Intel GPU(s):\n%s" "$intel_gpus"
fi

# Detect and print combinations
combination_detected=false

if [[ -n "$nvidia_gpus" && -n "$intel_gpus" ]]; then
    printf "Combination: NVIDIA + Intel\n"
    combination_detected=true
    gpu="nvidiaIntelPrime"
elif [[ -n "$amd_gpus" && -n "$intel_gpus" ]]; then
    printf "Combination: AMD + Intel\n"
    combination_detected=true
    gpu="amdIntelPrime"
elif [[ -n "$nvidia_gpus" ]]; then
    gpu="nvidia"
elif [[ -n "$amd_gpus" ]]; then
    gpu="amdgpu"
elif [[ -n "$intel_gpus" ]]; then
    gpu="intel"
else
    printf "No hybrid GPU combination detected.\n"
    gpu="unknown"
fi

# Update all .nix files in ./setups/
shopt -s nullglob
for nix_file in ./setups/*.nix; do
    if [[ -f "$nix_file" ]]; then
        sed -i -e "s/gpu = \".*\"/gpu = \"$gpu\"/" "$nix_file"
        printf "Updated %s with detected GPU information.\n" "$nix_file"
    else
        printf "No .nix files found in ./setups/.\n"
    fi
done