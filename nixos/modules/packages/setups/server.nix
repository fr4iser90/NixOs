#/etc/nixos/modules/packages/setup/server.nix
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
    nginx
    mariadb
    redis
    memcached
    php
    python3
    nodejs
    docker
    podman
    kubernetes
    virt-manager
    qemu
    rsnapshot
    borgbackup          
];

  services.openvscode-server.enable = true;
  virtualisation.docker.enable = true;
}