# /etc/nixos/modules/desktop/gpu/intel.nix
{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "intel" ]; # Use the Intel driver for integrated graphics
  boot.kernelModules = [ "kvm-intel" ];
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel   # Intel VA-API driver for video acceleration.
      intel-media-sdk 
    ];
  };

  # Additional configurations for Intel graphics
  hardware.video.intel = {
    enable = true;
    package = xorg.xf86video;
    sna = true;  # Enable SNA acceleration
    enableRC6 = true; # Enable power saving
    enableFBC = true; # Enable frame buffer compression
    enablePSR = true; # Enable Panel Self Refresh
  };


}
