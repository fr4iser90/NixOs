# /etc/nixos/modules/docker.nix

{ config, pkgs, ... }:

{
  services.docker.enable = true;
  services.docker.package = pkgs.docker;
  # Weitere Konfigurationsoptionen für Docker können hier hinzugefügt werden
}
