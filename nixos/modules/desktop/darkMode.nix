{ config, pkgs, ... }:
let
  env = import ../../env.nix;
in
{
  config = {
    # SDDM Dark Mode
    services.xserver.displayManager.sddm.theme = if env.darkMode then "breeze-dark" else "breeze";

    # Plasma Dark Mode
    environment.variables = if env.desktop == "plasma" && env.darkMode then {
      KDE_GLOBAL_THEME = "Breeze Dark";
    } else if env.desktop == "plasma" then {
      KDE_GLOBAL_THEME = "Breeze";
    };
  };
}
