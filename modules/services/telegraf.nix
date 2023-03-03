{ config, lib, pkgs, ... }: {
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 8080 ];
  };
  services.telegraf = {
    enable = true;
    environmentFiles = [ "/run/keys/telegraf.env" ];
    extraConfig = {
      inputs = {
        cpu = {
          percpu = true;
          totalcpu = false;
          fielddrop = [ "time_*" ];
        };
        disk = {
          ignore_fs = [ "tmpfs" "devtmpfs" "devfs" "iso9660" "overlay" "aufs" "squashfs" ];
        };
        httpjson = {
          name = "awair";
          servers = [ "http://192.168.0.92/air-data/latest" ];
          response_timeout = "10s";
          method = "GET";
        };
        http_listener_v2 ={
          service_address = ":8080";
          data_format = "json";
        };
      };
      outputs = {
        influxdb_v2 = {
          urls = [ "$\{INFLUX_URL\}" ];
          token = "$\{INFLUX_TOKEN\}";
          organization = "$\{INFLUX_ORG\}";
          bucket = "telegraf";
        };
      };
    };
  };
}
