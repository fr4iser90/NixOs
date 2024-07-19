#/etc/nixos/modules/packages/setup/multimedia.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lsof               
    git                
    wget              
    tree   
    firefox
    vlc
    fish
    kitty            
    plex
    kodi
    rhythmbox
    clementine
    spotify              
];

  programs.firefox.enable = true;
}