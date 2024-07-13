#/etc/modules/desktop/desktopManager.nix
{ config, pkgs, ... }:
let
  env = import ../../env.nix;
in
{
  services.xserver.desktopManager = {
    plasma5.enable = env.desktop == "plasma";
    gnome.enable = env.desktop == "gnome";
    xfce.enable = env.desktop == "xfce";
  };
}
