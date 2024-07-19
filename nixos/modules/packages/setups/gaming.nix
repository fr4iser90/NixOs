#/etc/nixos/modules/packages/setup/gaming.nix
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
    lutris
    wine
    winetricks
    wineWowPackages.full
    discord
    bitwarden-cli
    owncloud-client
    plex 
    ffmpeg
];

  programs.steam.enable = true;
  programs.firefox.enable = true;
}