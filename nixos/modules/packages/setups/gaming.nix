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
    alacritty            
    lutris
    heroic-games-launcher
    wine
    winetricks
    wineWowPackages.full
    proton
    discord
];

  programs.steam.enable = true;
  programs.firefox.enable = true;
}