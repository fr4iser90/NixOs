{ config, pkgs, ... }:

{
  users.groups.botchi = {
    gid = 1001;
  };

  users.users.botchi = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" "render" "tty" "users" "dbus" "systemd-journal" "botchi" ];
    group = "botchi";
    uid = 1001;
    home = "/home/botchi";
  };

  environment.systemPackages = with pkgs; [
  ];

  systemd.services."getty@tty7".enable = false;
  systemd.services."autovt@tty7".enable = false;
}
