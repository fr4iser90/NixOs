{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    weston
    sway
    wayland-utils
  ];
}
