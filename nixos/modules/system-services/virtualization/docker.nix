# /etc/nixos/modules/system-services/virtualization/docker.nix

{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker;
}
