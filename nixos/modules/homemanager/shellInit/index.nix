#/etc/nixos/modules/homemanager/shellInit/index.nix
{ pkgs, lib, defaultShell, ... }:

let
  env = import ../../../env.nix;
  shellInitFile = ./${env.defaultShell} + "Init.nix";
in
{
  programs = import shellInitFile { inherit pkgs lib; };
}
