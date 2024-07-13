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
}
