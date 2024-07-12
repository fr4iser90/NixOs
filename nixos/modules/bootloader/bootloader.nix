# /etc/nixos/modules/bootloader.nix

{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
#  boot.kernelParams = [ "acpi=noirq" "pci=noacpi" ];
}
