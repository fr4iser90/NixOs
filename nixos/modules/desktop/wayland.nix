#/etc/nixos/modules/desktop/wayland.nix
{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  environment.systemPackages = with pkgs; [
    weston
    sway
    wayland-utils
    xwayland
    pkgs.plasma-workspace
  ];


  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" "modestting" ];
      displayManager = {
        sddm = {
          enable = env.displayManager == "sddm";
          wayland = {
            enable = env.displayServer == "wayland";
          };
        };
        lightdm = {
          enable = env.displayManager == "lightdm";
        };
        gdm = {
          enable = env.displayManager == "gdm";
        };
        defaultSession = if env.desktop == "gnome" then "gnome" else if env.desktop == "plasma" then "plasma" else "xfce";
      };
      desktopManager = {
        plasma5 = {
          enable = env.desktop == "plasma";
        };
        gnome = {
          enable = env.desktop == "gnome";
        };
        xfce = {
          enable = env.desktop == "xfce";
        };
      };
    };
  };
}
