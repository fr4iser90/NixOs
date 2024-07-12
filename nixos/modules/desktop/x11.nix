#/etc/nixos/modules/desktop/x11.nix
{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  environment.systemPackages = with pkgs; [
    xorg.xinit
    xorg.libXtst
    util-linux
    xorg.xauth
    xorg.xf86videodummy
    xorg.xorgserver
    xorg.xrandr
    xorg.xhost
    sddm
  ];

 services.xserver.displayManager.sddm.enable = true;

  services.xserver = {
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
