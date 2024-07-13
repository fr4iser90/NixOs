#/etc/nixos/modules/packages/setup/multimedia.nix
{ pkgs, ... }:
with pkgs; [
    lsof               
    git                
    wget              
    tree   
    konsole
    htop
    tmux
    screen
    net-tools
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
    xorg
    xvfb
    weston
    x11vnc
    tigervnc
    xfce
    alacritty
    nomachine
    xrdp
    remmina
    virtualgl              
]

  virtualisation.docker.enable = true;
  programs.steam.enable = true;
  programs.firefox.enable = true;
  programs.fish.enable = true;