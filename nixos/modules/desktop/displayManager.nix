#/etc/modules/desktop/displayManager.nix
{ config, pkgs, ... }:
let
  env = import ../../env.nix;

  # Mapping von Session-Namen auf Standard-Sessions
  sessionMap = {
    gnome = "gnome";
    plasma = "plasma";
    plasmawayland = "plasmawayland";
    xfce = "xfce";
    i3 = "i3";
  };

  # Standard-Session bestimmen, falls keine passende gefunden wird
  defaultSession = if builtins.hasAttr env.session sessionMap
                   then builtins.getAttr env.session sessionMap
                   else "default";
in
{
  services.xserver.displayManager = {
    sddm.enable = env.displayManager == "sddm";
    lightdm.enable = env.displayManager == "lightdm";
    gdm.enable = env.displayManager == "gdm";
    defaultSession = defaultSession;
  };

  
  # Enable automatic login if specified in env.nix
  services.displayManager.autoLogin.enable = env.autoLogin;
  services.displayManager.autoLogin.user = env.mainUser;
}
