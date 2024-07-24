# /etc/nixos/config/home-mainuser.nix
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
  };

  home.packages = with pkgs; [
    # Add packages here
  ];
}
