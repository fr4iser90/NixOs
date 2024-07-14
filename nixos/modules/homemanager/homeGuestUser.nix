# /etc/nixos/config/home-guestuser.nix
{ pkgs, lib, user, ... }:

{
  home.stateVersion = "24.05";
  home.username = user;
  home.homeDirectory = lib.mkForce "/home/${user}";

  import ./shellInit/index.nix;


  home.sessionVariables = {

  };
}
