#/etc/nixos/modules/packages/setup/serverRemoteDesktop.nix
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lsof               
    git                
    wget              
    tree   
    kitty
    htop
    tmux
    screen
    nettools
    nmap
    ncdu
    iperf3
    ethtool
    openssh
    fail2ban
    iptables
    tcpdump
    rsync
    curl
    firefox
    vlc
    weston
    x11vnc
    tigervnc
    alacritty
    #nomachine-client
    xrdp
    remmina
    virtualgl              
];

  virtualisation.docker.enable = true;
  programs.steam.enable = true;
  programs.firefox.enable = true;
}