{ config, lib, pkgs, builtins, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8086 8123 ];
  };
  services.influxdb2 = {
    enable = true;
  };
  services.home-assistant = with pkgs; {
    enable = true;
    openFirewall = true;
    extraPackages = python3Packages: with python3Packages; [
      pyatv
    ];
    extraComponents = [
      "awair"
      "speedtestdotnet"
    ];
    config = {
      default_config = {};
      influxdb = {
        api_version = 2;
        ssl = false;
        verify_ssl = false;
        host = "localhost";
        port = 8086;
        token = builtins.readFile /run/keys/influx.token;
        organization = "dab3742f664a79c9";
        bucket = "hass";
        tags = {
          source = "hass";
        };
        default_measurement = "state";
        include = {
          domains = "sensor";
        };
      };
    };
  };
}
