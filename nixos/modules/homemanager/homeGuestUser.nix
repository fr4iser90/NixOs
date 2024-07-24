# /etc/nixos/config/home-guestuser.nix
{ pkgs, lib, user, config, ... }:

let
  env = import ../../env.nix;
  shellInitFile = ./shellInit/${env.defaultShell} + "Init.nix";
  shellInitModule = import (builtins.toString shellInitFile) { inherit pkgs lib; };
in
{
  home.stateVersion = "24.05";
  home.username = user;
  home.homeDirectory = lib.mkForce "/home/${user}";
  

  imports = [ shellInitModule ];

  home.sessionVariables = {
    EMAIL = "${env.email}";
    DOMAIN = "${env.domain}";
    CERTEMAIL = "${env.certEmail}";
  };

  home.packages = with pkgs; [
    # Add packages here
  ];
}
