{ config, lib, pkgs, ... }: {
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
