{ config, pkgs, ... }:

{

  # Define the systemd service for the second user using weston
  systemd.services.start-second-user-wayland = {
    description = "Start Wayland Session for Second User";
    after = [ "graphical.target" ];
    wantedBy = [ "graphical.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScriptBin "start-second-user-wayland" ''
        #!/bin/bash
        sudo -u botchi dbus-run-session \
          ${pkgs.weston}/bin/weston --backend=fbdev-backend.so --tty=7 --width=1920 --height=1080 --fullscreen
      ''}";
      User = "fr4iser";
    };
  };

  # Ensure the primary display uses AMDGPU
  hardware.opengl.enable = true;
}
