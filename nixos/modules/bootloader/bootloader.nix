# /etc/nixos/modules/bootloader.nix

{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "softdog" ];

  boot.kernelParams = [
    "kernel.panic=10"          # Restart 10 seconds after a kernel panic
    "kernel.panic_on_oops=1"   # Restart on 'oops' (serious error)
    #"acpi=noirq"
    #"pci=noacpi"
  ];
}
