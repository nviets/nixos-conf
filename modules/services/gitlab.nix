{ config, lib, pkgs, ... }: {
    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 80 8080 ];
    };
  services = with pkgs; {
    gitlab = {
      enable = true;
      port = 80;
      databasePasswordFile = pkgs.writeText "dbPassword" "xo0daiF4";
      initialRootPasswordFile = pkgs.writeText "rootPassword" "notproduction";
      smtp.enable = true;
      secrets = {
        dbFile = "/var/keys/gitlab/db";
        secretFile = "/var/keys/gitlab/secret";
        otpFile = "/var/keys/gitlab/otp";
        jwsFile = "/var/keys/gitlab/jws";
      };
      pages.settings.pages-domain = "mini.com";
      extraConfig = {
        ldap.enabled = true;
        gitlab = {
          email_from = "nathan@localhost";
          email_display_name = "Example GitLab";
          email_reply_to = "nathan@localhost";
          default_projects_features = { builds = false; };
        };
      };
    };
    gitlab-runner = {
      enable = true;
      services = {
        default = {
    # File should contain at least these two variables:
    # `CI_SERVER_URL`
    # `REGISTRATION_TOKEN`
    registrationConfigFile = "/var/keys/gitlab/gitlab-runner-registration";
    executor = "shell";
    tagList = [ "shell" ];
  };
      };
    };
    nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts."git.example.com" = {
        enableACME = false;
        forceSSL = false;
        locations."/".proxyPass =
          "http://unix:/run/gitlab/gitlab-workhorse.socket";
      };
    };
  };
}
