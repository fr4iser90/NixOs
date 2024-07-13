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
    kvm
    rsnapshot
    borgbackup              
]

  virtualisation.docker.enable = true;
  programs.fish.enable = true;