# weston-module.nix
{ config, pkgs, lib, ... }:

with lib;

{
  options.services.weston = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Weston service";
    };

    config = mkOption {
      type = types.str;
      default = /etc/nixos/config/weston.ini;
      description = "The Weston configuration";
    };

    user = mkOption {
      type = types.str;
      default = "botchi";
      description = "User to run Weston";
    };

    display = mkOption {
      type = types.str;
      default = ":99";
      description = "Display to use for Weston";
    };

    virtualDisplay = mkOption {
      type = types.bool;
      default = true;
      description = "Enable virtual display for Weston";
    };
  };

  config = mkIf config.services.weston.enable {
    systemd.user.services.weston = {
      description = "Weston compositor";
      after = [ "graphical.target" ];

      serviceConfig = {
        #User = config.services.weston.user;
        Environment = [
          "DISPLAY=:99"
          "XDG_RUNTIME_DIR=/run/user/1001"
        ];
        ExecStart = ''
          ${pkgs.weston}/bin/weston --backend=headless-backend.so --config=/etc/nixos/config/weston.ini
        '';
      };
    };
  };
}
