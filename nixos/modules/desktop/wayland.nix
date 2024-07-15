#/etc/nixos/modules/desktop/wayland.nix
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    weston
    sway
    wayland-utils
    xwayland
    plasma-workspace
  ];
  services.xserver.displayManager.sddm.wayland.enable = true;
}
