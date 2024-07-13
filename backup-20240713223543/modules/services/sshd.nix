{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon (sshd)
  services.openssh.enable = true;

  # Optional: Customize SSH settings
  services.openssh.settings = {
    PermitRootLogin = "prohibit-password"; # Disable root login with password
    PasswordAuthentication = true;         # Enable password authentication
    # You can add more settings here if needed
  };

  # Enable and configure the firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];  # Open SSH port
  };
}
