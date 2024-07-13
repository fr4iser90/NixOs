{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    xorg.xinit       # sunshine
    xorg.libXtst     # sunshine
    util-linux       # hex sunshine
    xorg.xauth
    xorg.xf86videodummy
  ];
}
