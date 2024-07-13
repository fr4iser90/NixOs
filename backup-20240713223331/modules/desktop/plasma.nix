# /etc/nixos/modules/desktop/plasma.nix
{ config, pkgs, ... }:

{
  services.xserver.desktopManager.plasma5.enable = true;

  environment.systemPackages = with pkgs; [
    plasma5Packages.plasma-desktop
  ];
}
