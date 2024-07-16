{ config, pkgs, ... }:


{
  # Installieren von CrowdSec
  services.crowdsec = {
    enable = true;
    # Weitere spezifische Konfigurationen für CrowdSec
  };

  # Stellen Sie sicher, dass der Traefik-CrowdSec-Bouncer läuft
  services.traefik-crowdsec-bouncer = {
    enable = true;
    # Weitere spezifische Konfigurationen für den Bouncer
  };

  services.traefik = {
    enable = true;
    authUsers = [
      "User:hashedPassword",       #apache 2  password hashen eintragen.. 
      # Weitere Benutzer hinzufügen
    ];
    package = pkgs.traefik;
    extraConfig = ''
      [entryPoints]
        [entryPoints.http]
          address = ":80"

      [providers.file]
        filename = "/etc/traefik/dynamic_conf.yml"
        watch = true

      [api]
        dashboard = true
        insecure = true
    '';
  };

  # Stellen Sie sicher, dass die Konfigurationsdatei an den richtigen Ort kopiert wird
  environment.etc."traefik/dynamic_conf.yml".source = ./path/to/your/dynamic_conf.yml;
}
