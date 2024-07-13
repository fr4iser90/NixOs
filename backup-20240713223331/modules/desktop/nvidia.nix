{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    pkgs.linuxPackages.nvidia_x11
    libglvnd
    mesa
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    prime = {
      offload.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ vulkan-loader ];
  };
}
