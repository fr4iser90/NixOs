#/etc/nixos/modules/desktop/common.nix
{ config, lib, pkgs, ... }:

let
  env = import ../../env.nix;
  displayServerConfig = if env.displayServer == "wayland" then import ./wayland.nix { inherit config pkgs; } else import ./x11.nix { inherit config pkgs; };
  gpuConfig = if env.gpu == "nvidia" then import ./nvidia.nix { inherit config pkgs; } else import ./amdgpu.nix { inherit config pkgs; };
in {
  imports = [ displayServerConfig gpuConfig ];
  
  console.keyMap = "de";
  # Konfiguration des X-Servers
  services.xserver = {
    enable = true;    
    xkb.layout = "de";   
    xkb.options = "eurosign:e";
    videoDrivers = [ "env.gpu" ];

    
    displayManager = {   
      sddm.enable = env.displayManager == "sddm";
      lightdm.enable = env.displayManager == "lightdm";
      gdm.enable = env.displayManager == "gdm";
      defaultSession = if env.desktop == "gnome" then "gnome" else if env.desktop == "plasma" then "plasma" else "xfce";
    };

    desktopManager = {   
      plasma5.enable = env.desktop == "plasma";
      gnome.enable = env.desktop == "gnome";
      xfce.enable = env.desktop == "xfce";
    };
 };
}




