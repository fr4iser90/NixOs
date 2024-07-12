{ pkgs, ...}:
with pkgs; [
  lutris
  wine
  wineWowPackages.full
  winetricks
]
