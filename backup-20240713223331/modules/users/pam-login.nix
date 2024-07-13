# pam-login.nix
{ config, pkgs, lib, ... }:

{
  security.pam.services.login = {
    text = ''
      # Account management.
      account required pam_unix.so

      # Authentication management.
      auth optional pam_unix.so likeauth nullok
      auth sufficient pam_unix.so likeauth nullok try_first_pass
      auth required pam_deny.so

      # Password management.
      password sufficient pam_unix.so nullok yescrypt

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
      session required pam_loginuid.so
      session required pam_lastlog.so silent
      session optional pam_systemd.so
    '';
  };
}
