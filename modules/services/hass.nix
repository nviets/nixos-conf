{ config, lib, pkgs, ... }: {
  services.home-assistant = with pkgs; {
    enable = true;
    extraComponents = [
      "speedtestdotnet"
      "met"
      "radio_browser"
      "awair"
      "api"
      "mqtt"
      "influxdb"
    ];
    config = {
      default_config = { };
      influxdb = {
        api_version = 2;
        ssl = false;
        host = "192.168.0.236";
        port = 8086;
        token =
          "5-fa4xxWxASJyVHMJ3deAGyUCfAvsMqktXwb9RSPLY7li5RXhAoWIDbS0MI-IlaF0xJTYUHKuexrlMe7k0uJsQ==";
        organization = "b34935d59f40ee0e";
        bucket = "hass";
      };
      sensor = {
        platform = "rest";
        resource = "http://192.168.0.92/air-data/latest";
        json_attributes = [
          "timestamp"
          "score"
          "dew_point"
          "temp"
          "humid"
          "abs_humid"
          "co2"
          "co2_est"
          "co2_est_baseline"
          "voc"
          "voc_baseline"
          "voc_h2_raw"
          "pm25"
          "pm10_est"
        ];
        name = "Awair";
        value_template = "{{ value_json.timestamp }}";
      };
    };
  };
}
