{ config, pkgs, ... }:

let
  env = import ../../../env.nix;
in
{
  programs.${defaultBrowser}.enable = true;
}
