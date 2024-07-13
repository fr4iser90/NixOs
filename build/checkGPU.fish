#!/usr/bin/env fish

# Ensure pciutils (lspci) is installed
if not command -v lspci > /dev/null
  echo "pciutils (lspci) is not installed. Installing pciutils..."
  nix-env -iA nixos.pciutils

  # Check if installation was successful
  if not command -v lspci > /dev/null
    echo "Failed to install pciutils. Please install it manually using your package manager."
    exit 1
  end
end

# Check if grep is installed
if not command -v grep > /dev/null
  echo "grep is not installed. Please install it using your package manager."
  exit 1
end

# List all PCI devices and filter for GPU-related entries
set gpu_info (lspci | grep -i 'vga\|3d\|2d')

# Check if any GPU information was found
if test -z "$gpu_info"
  echo "No GPU found on this system."
  exit 1
end

# Initialize variables to store GPU information
set amd_gpus ""
set nvidia_gpus ""
set intel_gpus ""

# Process each line of the GPU info
for line in $gpu_info
  if echo $line | grep -qi 'AMD\|ATI'
    set amd_gpus $amd_gpus $line
  else if echo $line | grep -qi 'NVIDIA'
    set nvidia_gpus $nvidia_gpus $line
  else if echo $line | grep -qi 'Intel'
    set intel_gpus $intel_gpus $line
  end
end

# Print the GPU information
echo "GPU(s) found on this system:"

if test -n "$amd_gpus"
  echo "AMD GPU(s):"
  echo $amd_gpus
end

if test -n "$nvidia_gpus"
  echo "NVIDIA GPU(s):"
  echo $nvidia_gpus
end

if test -n "$intel_gpus"
  echo "Intel GPU(s):"
  echo $intel_gpus
end

# Detect and print combinations
set combination_detected false

if test -n "$nvidia_gpus" -a -n "$intel_gpus"
  echo "Combination: NVIDIA + Intel"
  set combination_detected true
  set gpu "nvidiaIntelPrime"
else if test -n "$amd_gpus" -a -n "$intel_gpus"
  echo "Combination: AMD + Intel"
  set combination_detected true
  set gpu "amdIntelPrime"
else if test -n "$nvidia_gpus"
  set gpu "nvidia"
else if test -n "$amd_gpus"
  set gpu "amdgpu"
else if test -n "$intel_gpus"
  set gpu "intel"
else
  echo "No hybrid GPU combination detected."
  set gpu "unknown"
end


# Update all .nix files in ./setups/
for nix_file in ./setups/*.nix
  if test -f $nix_file
    sed -i -e "s/gpu = \".*\"/gpu = \"$gpu\"/" $nix_file
    echo "Updated $nix_file with detected GPU information."
  else
    echo "No .nix files found in ./setups/."
  end
end
