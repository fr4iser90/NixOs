# /etc/nixos/modules/desktop/xfce.nix
{ config, pkgs, ... }:

{
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;

  environment.systemPackages = with pkgs; [
    xfce.xfce4
  ];
}
