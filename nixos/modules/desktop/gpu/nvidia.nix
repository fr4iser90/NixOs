# /etc/nixos/modules/desktop/gpu/nvidia.nix
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];  # Use NVIDIA driver

  hardware.nvidia = {
    modesetting.enable = true;  # Enable modesetting for NVIDIA
    nvidiaSettings = true;  # Enable nvidia-settings
    package = config.boot.kernelPackages.nvidiaPackages.production;  # Use the production driver
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      config.boot.kernelPackages.nvidiaPackages.production
    ];
  };


  # NVIDIA driver options (uncomment to use a different version)
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;       # Stable driver
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;         # Beta driver
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;   # Production driver (default, installs 550)
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;  # Vulkan beta driver
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_470;   # Legacy driver (470 series)
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;   # Legacy driver (390 series)
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_340;   # Legacy driver (340 series)
}
