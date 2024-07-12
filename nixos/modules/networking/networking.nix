# /etc/nixos/modules/networking.nix
{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  networking.hostName = env.hostName; # Define your hostname.
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Berlin";
}
