{ config, pkgs, ... }:

let
  envDir = ./traefik-crowdsec-stack/config;
  crowdsecConfigDir = ./traefik-crowdsec-stack/crowdsec/config;
  traefikConfigDir = ./traefik-crowdsec-stack/traefik;
  traefikAuthUsersFile = ../../../../secrets/traefik.env;
  traefikAuthUsers = builtins.readFile traefikAuthUsersFile;

  envFile = { path, fileName }:
    pkgs.writeTextFile {
      name = fileName;
      destination = "/etc/envs/${fileName}";
      text = builtins.readFile path;
    };
in
{
  services = {
    networking.firewall.allowedTCPPorts = [ 80 443 ];

    # Crowdsec service
    crowdsec = {
      enable = true;
      package = pkgs.crowdsec;
      environmentFiles = [ (envFile { path = "${envDir}/crowdsec.env"; fileName = "crowdsec.env"; }) ];
      extraConfig = ''
        Hostname = "${SERVICES_CROWDSEC_HOSTNAME:-crowdsec}"
        DNS = [ "1.1.1.1" "8.8.8.8" ]
        HealthCheck = {
          Test = ["CMD", "cscli", "version"];
          Interval = "20s";
          Timeout = "2s";
          Retries = 5;
          StartPeriod = "10s";
        }
      '';
      volumes = [
        { source = "/etc/localtime"; target = "/etc/localtime"; readOnly = true; }
        { source = "/var/run/docker.sock"; target = "/var/run/docker.sock"; readOnly = true; }
        { source = "/var/log/auth.log"; target = "/var/log/auth.log"; readOnly = true; }
        { source = "/var/log/traefik"; target = "/var/log/traefik"; readOnly = true; }
        { source = "${crowdsecConfigDir}"; target = "/etc/crowdsec"; }
        { source = "${crowdsecConfigDir}/data"; target = "/var/lib/crowdsec/data"; }
      ];
      restartPolicy = "unless-stopped";
      securityOptions = ["no-new-privileges=true"];
    };

    # Traefik service
    traefik = {
      enable = true;
      package = pkgs.traefik;
      environment = {
        traefikAuthUsers = traefikAuthUsers;
      };
      environmentFiles = [ (envFile { path = "${envDir}/traefik.env"; fileName = "traefik.env"; }) ];
      extraConfig = ''
        Hostname = "${SERVICES_TRAEFIK_HOSTNAME:-traefik}"
        DNS = [ "127.0.0.1" "1.1.1.1" "8.8.8.8" ]
        HealthCheck = {
          Test = ["CMD", "traefik", "healthcheck", "--ping"];
          Interval = "10s";
          Timeout = "1s";
          Retries = 3;
          StartPeriod = "10s";
        }
        Labels = {
          "traefik.docker.network" = "proxy";
          "traefik.enable" = "true";
          "traefik.http.routers.traefik.entrypoints" = "websecure";
          "traefik.http.routers.traefik.middlewares" = "default@file,traefikAuth@file";
          "traefik.http.routers.traefik.rule" = "Host(${SERVICES_TRAEFIK_LABELS_TRAEFIK_HOST})";
          "traefik.http.routers.traefik.service" = "api@internal";
          "traefik.http.routers.traefik.tls" = "true";
          "traefik.http.routers.traefik.tls.certresolver" = "http_resolver";
          "traefik.http.services.traefik.loadbalancer.sticky.cookie.httpOnly" = "true";
          "traefik.http.services.traefik.loadbalancer.sticky.cookie.secure" = "true";
          "traefik.http.routers.pingweb.rule" = "PathPrefix(`/ping`)";
          "traefik.http.routers.pingweb.service" = "ping@internal";
          "traefik.http.routers.pingweb.entrypoints" = "websecure";
        }
      '';
      dependsOn = [ "crowdsec" ];
      volumes = [
        { source = "/etc/localtime"; target = "/etc/localtime"; readOnly = true; }
        { source = "/var/run/docker.sock"; target = "/var/run/docker.sock"; readOnly = true; }
        { source = "/var/log/traefik/"; target = "/var/log/traefik/"; }
        { source = "${traefikConfigDir}/traefik.yml"; target = "/traefik.yml"; readOnly = true; }
        { source = "${traefikConfigDir}/acme_letsencrypt.json"; target = "/acme_letsencrypt.json"; }
        { source = "${traefikConfigDir}/tls_letsencrypt.json"; target = "/tls_letsencrypt.json"; }
        { source = "${traefikConfigDir}/dynamic_conf.yml"; target = "/dynamic_conf.yml"; }
      ];
      restartPolicy = "unless-stopped";
      securityOptions = ["no-new-privileges:true"];
    };

    # Traefik Crowdsec Bouncer service
    traefik_crowdsec_bouncer = {
      enable = true;
      package = pkgs.traefikCrowdsecBouncer;
      environmentFiles = [ (envFile { path = "${envDir}/traefik-crowdsec-bouncer.env"; fileName = "traefik-crowdsec-bouncer.env"; }) ];
      extraConfig = ''
        Hostname = "${SERVICES_TRAEFIK_CROWDSEC_BOUNCER_HOSTNAME:-traefik-crowdsec-bouncer}"
        DNS = [ "1.1.1.1" "8.8.8.8" ]
      '';
      dependsOn = [ "crowdsec" ];
      volumes = [];
      restartPolicy = "unless-stopped";
    };
  };

  networking = {
    networks = {
      proxy = {
        driver = "bridge";
        ipam = {
          config = [{
            subnet = "${NETWORKS_PROXY_SUBNET_IPV4:-172.40.0.0/16}";
          }];
        };
        attachable = true;
      };

      crowdsec = {
        driver = "bridge";
        ipam = {
          config = [{
            subnet = "${NETWORKS_CROWDSEC_SUBNET_IPV4:-172.41.0.0/16}";
          }];
        };
        attachable = true;
      };
    };
  };
}
