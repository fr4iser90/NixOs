{ config, lib, pkgs, ... }:

with lib;

{
  imports = [];

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
#      pkgs.linuxPackages.nvidia_x11
#      nvidia-utils
#      nvidia-settings
    ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 47990 47999 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };

  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };

  environment.systemPackages = with pkgs; [
    sunshine
    pipewire
    libva
    xorg.xinput
    libva-utils
    util-linux
    xorg.libXtst
#    pkgs.linuxPackages.nvidia_x11
  ];

  systemd.services.sunshine = {
    description = "Sunshine Game Stream Host";
    after = [ "network.target" "multi-user.target" "graphical.target" ];
    wantedBy = [ "graphical.target" ];

    serviceConfig = {
#      User = "fr4iser";
#      ExecStart = "/home/fr4iser/scripts/start-shunshine.fish";
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "always";
      AmbientCapabilities = [ "CAP_SYS_ADMIN" ];
      Environment = [ 
        "LIBVA_DRIVER_NAME=nvidia" 
        "WAYLAND_DISPLAY=wayland-0"
      ];
    };
  };
}

