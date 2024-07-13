#/etc/nixos/modules/packages/setup/multimedia.nix
{ pkgs, ... }:
with pkgs; [
    lsof               
    git                
    wget              
    tree   
    firefox
    vlc
    fish
    alacritty            
    plex
    kodi
    rhythmbox
    clementine
    spotify              
]

  programs.firefox.enable = true;
  programs.fish.enable = true;