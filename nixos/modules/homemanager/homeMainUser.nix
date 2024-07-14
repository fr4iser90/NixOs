# /etc/nixos/config/home-mainuser.nix
{ pkgs, lib, user, ... }:

let
  env = import ../../env.nix;
in
{
  home.stateVersion = "24.05";
  home.username = user;
  home.homeDirectory = lib.mkForce "/home/${user}";

  import ./shellInit/index.nix;


  home.sessionVariables = {
  };

  home.packages = with pkgs; [
    # Weitere benutzerspezifische Pakete hier hinzufügen
  ];
}
