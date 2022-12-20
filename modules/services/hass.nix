{ config, lib, pkgs, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8086 8123 ];
  };
  services.influxdb2 = {
    enable = true;
  };
  services.home-assistant = with pkgs; {
    enable = true;
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
        host = "mini";
        port = 8086;
        token =
          "YBNgGXuBCg5caAbSEpk8zOcs_TQzZ0720k7cB2_aTN0mLLEYm0LHhDHhkCHUoUJT-dzVhlFk8NgWTdbBX7LeSQ==";
        organization = "77baf2d7fdfe57b3";
        bucket = "hass";
        default_measurement = "state";
      };
    };
  };
}
