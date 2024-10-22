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
    lm_sensors
];


  services.openvscode-server.enable = true;
  virtualisation.docker.enable = true;

  systemd.services."systemd-watchdog" = {
    enable = true;
  };

  # Systemd-Service zur Temperaturüberwachung und Neustart bei zu hoher Temperatur
  systemd.services.tempMonitor = {
    description = "Überwacht die CPU-Temperatur und startet bei Überschreitung eines Grenzwertes den Server neu";
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c ''\
        CPU_TEMP=$(sensors | grep 'Package id 0:' | awk '{print $4}' | cut -d \"+\" -f2 | cut -d \".\" -f1); \
        if [ $CPU_TEMP -ge 90 ]; then systemctl reboot; fi''";
    };
    serviceConfig.Type = "simple";
    wantedBy = [ "multi-user.target" ];
  };

  # Systemd-Timer, um den Temperaturüberwachungsdienst alle 5 Minuten auszuführen
  systemd.timers.tempMonitor = {
    description = "Führt die Temperaturüberwachung alle 5 Minuten aus";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*:0/5";  # Alle 5 Minuten ausführen
      Persistent = true;
    };
  };
}
