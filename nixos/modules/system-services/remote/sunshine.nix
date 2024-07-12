{ config, lib, pkgs, ... }:

with lib;

{
  imports = [];

  #if needed kernelModules to load
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
    ];
  };

  #Uncomment to enable wake on lan
  networking.interfaces.enp2s0 = {
    wakeOnLan = {
      enable = true;
    };
  };

  #Port config enable these ports in your router to open sunshine for public accessibility
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 47990 47999 48010 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48000; }
      { from = 8000; to = 8010; }
    ];
  };

  #If a SecurityWrapper is needed (tried a mutli user session setup ( local use / + remote headless gaming)
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };

  #Environment packages for sunshine ,
  environment.systemPackages = with pkgs; [
    sunshine
    pipewire # or pulseaudio
    libva
    xorg.xinput
    libva-utils
    util-linux
    xorg.libXtst
  ];

  #SystemD to start sunshineService
  systemd.services.sunshine = {
    description = "Sunshine Game Stream Host";
    after = [ "network.target" "multi-user.target" "graphical.target" ];
    wantedBy = [ "graphical.target" ];

    serviceConfig = {
#      User = "{user}";
#      ExecStart = "/home/{user}/scripts/start-shunshine.fish";
      ExecStart = "${pkgs.sunshine}/bin/sunshine";
      Restart = "always";
      AmbientCapabilities = [ "CAP_SYS_ADMIN" ];
      Environment = [
        "LIBVA_DRIVER_NAME=nvidia"  # radeonsi
        "WAYLAND_DISPLAY=wayland-0"
      ];
    };
  };
}


