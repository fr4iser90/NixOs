# /etc/nixos/modules/services/x-server-guest.nix
{ config, pkgs, ... }:

{

imports = [ ./weston.nix ];

  # Define the systemd service for the second user using weston
  systemd.services.start-second-user-wayland = {
    description = "Start Wayland Session for Second User";
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "simple";
#      ExecStart = "dbus-run-session /run/current-system/sw/bin/weston --backend=headless-backend.so --width=1920 --height=1080 --socket=headless-0";
      ExecStart = "/etc/start-second-user-wayland.fish";
      User = "botchi";
      CapabilityBoundingSet = [ "CAP_SYS_ADMIN" "CAP_SYS_TTY_CONFIG" "CAP_SYS_RAWIO" "CAP_NET_ADMIN" "CAP_SYS_CHROOT" "CAP_MKNOD" "CAP_DAC_OVERRIDE" "CAP_FOWNER" ];
      AmbientCapabilities = [ "CAP_SYS_ADMIN" "CAP_SYS_TTY_CONFIG" "CAP_SYS_RAWIO" "CAP_NET_ADMIN" "CAP_SYS_CHROOT" "CAP_MKNOD" "CAP_DAC_OVERRIDE" "CAP_FOWNER" ];
      Environment = [
        "XDG_RUNTIME_DIR=/run/user/1001"
        "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1001/bus"
        "WAYLAND_DISPLAY=headless-0"
        "LIBVA_DRIVER_NAME=radeonsi"
      ];
    };
  };

  # Ensure the primary display uses AMDGPU
  hardware.graphics.enable = true;
}
