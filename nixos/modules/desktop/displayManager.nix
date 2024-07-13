#/etc/modules/desktop/displayManager.nix
{ config, pkgs, ... }:
let
  env = import ../../env.nix;
in
{
  services.xserver.displayManager = {
    sddm.enable = env.displayManager == "sddm";
    lightdm.enable = env.displayManager == "lightdm";
    gdm.enable = env.displayManager == "gdm";
    defaultSession = if env.desktop == "gnome" then "gnome" else if env.desktop == "plasma" then "plasma" else "xfce";
  };

  # Enable automatic login if specified in env.nix
  services.displayManager.autoLogin.enable = env.autoLogin;
  services.displayManager.autoLogin.user = env.mainUser;
}
