{ config, lib, pkgs, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8080 8091 8095 ];
  };
  services.jira = {
    enable = true;
    jrePackage = pkgs.jdk11;
    listenAddress = "192.168.0.236";
    proxy.enable = false;
  };
}
