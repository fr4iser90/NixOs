# /etc/nixos/modules/desktop/nvidia.nix
{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.layout = "de";  # Beispiel für Tastaturlayout
  services.xserver.xkbOptions = "eurosign:e";
  # Enable Wayland if desired
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.wayland.enable = false;
  services.xserver.displayManager.defaultSession = "plasma";

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    powerManagement.enable = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      config.boot.kernelPackages.nvidiaPackages.production
      pkgs.libvdpau
      pkgs.libva
    ];
  };

  # Install necessary X11 packages
  environment.systemPackages = with pkgs; [
    xorg.xorgserver
    xorg.xinit
    xorg.xauth
    xorg.xrdb
    xorg.xrandr
    xorg.xsetroot
    xorg.xmodmap
    xorg.xset
    plasma-workspace
  ];  
}
