{ config, lib, pkgs, ... }: {
  services = with pkgs; {
    gitlab = {
      enable = true;
      databasePasswordFile = pkgs.writeText "dbPassword" "xo0daiF4";
      initialRootPasswordFile = pkgs.writeText "rootPassword" "notproduction";
      smtp.enable = true;
      secrets = {
        dbFile = "/var/keys/gitlab/db";
        secretFile = "/var/keys/gitlab/secret";
        otpFile = "/var/keys/gitlab/otp";
        jwsFile = "/var/keys/gitlab/jws";
      };
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
