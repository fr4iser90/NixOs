{ config, lib, pkgs, ... }:

with lib;

{
  imports = [];

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      pipewire
      libva
      xorg.xinput
      libva-utils
      util-linux
      xorg.libXtst
      mesa
      libcap
    ];
  };

  services.dbus.enable = true;
  services.udev.packages = [ pkgs.libinput ];

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
    capabilities = "cap_sys_admin+p cap_net_admin+p cap_sys_tty_config+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };

  environment.systemPackages = with pkgs; [
    sunshine
    pipewire
    libva
    xorg.xinput
    libva-utils
    vaapiVdpau
    mesa
    util-linux
    xorg.libXtst
  ];

  systemd.services.start-sunshine-user = {
    description = "Start Sunshine for Botchi User";
    after = [ "multi-user.target" ];
   # wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
#      ExecStart = "${pkgs.systemd}/bin/machinectl shell botchi@ /bin/bash -c \"export XDG_RUNTIME_DIR=/run/user/1001; export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1001/bus; export WAYLAND_DISPLAY=headless-0; export LIBVA_DRIVER_NAME=radeonsi; systemctl --user start sunshine\"";
      ExecStart = "${pkgs.systemd}/bin/machinectl shell botchi@ /bin/bash -c \"systemctl start sunshine\"";
      User = "root";
    };
  };

  systemd.services.sunshine = {
    description = "Sunshine Game Stream Host";
#    after = [ "default.target" ];
    after = [ "start-second-user-wayland.service" ];
    wantedBy = [ "graphical.target" ];

    serviceConfig = {
      Type = "simple";
      User = "botchi";
#      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      ExecStart = "/etc/start-second-user-sunshine.fish";
      Restart = "always";
      CapabilityBoundingSet = [ "CAP_SYS_ADMIN" "CAP_SYS_TTY_CONFIG" "CAP_SYS_RAWIO" "CAP_NET_ADMIN" "CAP_SYS_CHROOT" ];
      AmbientCapabilities = [ "CAP_SYS_ADMIN" "CAP_SYS_TTY_CONFIG" "CAP_SYS_RAWIO" "CAP_NET_ADMIN" "CAP_SYS_CHROOT" ];
      Environment = [ 
        "LIBVA_DRIVER_NAME=radeonsi" 
        "WAYLAND_DISPLAY=headless-0"
        "XDG_RUNTIME_DIR=/run/user/1001"
        "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1001/bus"
        "XDG_SESSION_TYPE=wayland"

      ];
    };
  };
}
