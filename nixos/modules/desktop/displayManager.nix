#/etc/modules/desktop/displayManager.nix
{ config, pkgs, ... }:
let
  env = import ../../env.nix;

  # Determine the default session based on the desktop environment
  defaultSession = 
    if env.desktop == "gnome" then "gnome"
    else if env.desktop == "plasma" then "plasma"
    else if env.desktop == "xfce" then "xfce"
    else if env.desktop == "i3" then "i3"
    else "default";

    sddmWayland = env.desktop == "plasma" && env.displayManager == "sddm";
in
{
  services.xserver.displayManager = {
    sddm.enable = env.displayManager == "sddm";
    lightdm.enable = env.displayManager == "lightdm";
    gdm.enable = env.displayManager == "gdm";
    defaultSession = defaultSession;
  };

  
  # Enable automatic login if specified in env.nix
  services.xserver.displayManager.autoLogin.enable = env.autoLogin;
  services.xserver.displayManager.autoLogin.user = env.mainUser;
}
