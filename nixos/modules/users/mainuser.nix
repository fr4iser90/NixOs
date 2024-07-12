{ config, pkgs, ... }:

let
  env = import ../../env.nix;
in
{
  users.users."${env.mainUser}" = {
    isNormalUser = true;
    extraGroups = [ "tty" "networkmanager" "wheel" "docker" "video" "audio" "render" "input"  ];
    shell = pkgs.fish;
    home = "/home/${env.mainUser}";
    hashedPasswordFile = "/etc/nixos/secrets/password/.password";
  };

#  services.displayManager.autoLogin.enable = true;
#  services.displayManager.autoLogin.user = env.mainUser;

  # Enable linger for the main user to allow user services to run after logout
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;
}
