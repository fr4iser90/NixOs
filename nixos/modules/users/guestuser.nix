{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  users.users."${env.guestUser}" = {
    isNormalUser = true;
    extraGroups = [ "tty" "networkmanager" "docker" ];
    home = "/home/${env.guestUser}";
    shell = pkgs.${env.defaultShell};
  };

  systemd.services."getty@tty3".enable = false;
  systemd.services."autovt@tty3".enable = false;

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.enable = true;

}
