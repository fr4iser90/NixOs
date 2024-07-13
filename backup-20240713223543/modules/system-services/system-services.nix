# /etc/nixos/modules/system-services.nix

{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
#  services.docker.enable = true;
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
