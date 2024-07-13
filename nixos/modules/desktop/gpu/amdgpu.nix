{ config, pkgs, ... }:

{
  services.xserver.videoDrivers = [ "amdgpu" ];

  environment.systemPackages = with pkgs; [
    libva-utils
    vaapiVdpau
    libvdpau-va-gl
  ];

  hardware.graphics.extraPackages = with pkgs; [ vulkan-loader ];
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [ libva mesa ];
}
