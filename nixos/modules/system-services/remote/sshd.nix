{ config, pkgs, ... }:

{
  services.openssh.enable = true;

  services.openssh.settings = {
    PermitRootLogin = "prohibit-password";
    PasswordAuthentication = true;
  };

  networking.firewall = { 
    enable = true;
    allowedTCPPorts = [ 22 ];
  };
}
