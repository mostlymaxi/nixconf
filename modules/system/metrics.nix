{ config, lib, ... }:

let
  cfg = config.services.metrics;
in
{
  options.services.metrics = {
    enable = lib.mkEnableOption "metrics exporting via Prometheus node exporter" // {
      example = lib.literalExpression "true";
    };

    grafanaCloud = {
      enable = lib.mkEnableOption "push metrics to Grafana Cloud" // {
        example = lib.literalExpression "true";
        description = "Whether to push metrics to Grafana Cloud";
      };

      prometheusUrl = lib.mkOption {
        type = lib.types.str;
        example = "https://prometheus-us-central1.grafana.net/api/prom/push";
        description = "Grafana Cloud Prometheus remote write URL";
      };

      prometheusUsername = lib.mkOption {
        type = lib.types.str;
        example = "3055526";
        description = "Grafana Cloud Prometheus username";
      };

      apiKeyFile = lib.mkOption {
        type = lib.types.str;
        description = "Path to file containing Grafana Cloud API key";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.prometheus = {
        enable = true;
        port = 9090;

        exporters = {
          node = {
            enable = true;
            enabledCollectors = [
              "systemd"
              "logind"
              "diskstats"
              "filesystem"
              "meminfo"
              "netdev"
              "time"
            ];
          };
        };

        globalConfig.scrape_interval = "5m";

        scrapeConfigs = [
          {
            job_name = "node-exporter";
            static_configs = [
              {
                targets = [ "localhost:9100" ];
              }
            ];
          }
        ];
      };

    })

    (lib.mkIf (cfg.enable && cfg.grafanaCloud.enable) {
      services.prometheus = {
        remoteWrite = [
          {
            url = cfg.grafanaCloud.prometheusUrl;
            basic_auth = {
              username = cfg.grafanaCloud.prometheusUsername;
              password_file = cfg.grafanaCloud.apiKeyFile;
            };
            queue_config = {
              capacity = 2000;
              max_samples_per_send = 1000;
              batch_send_deadline = "5m";
            };
          }
        ];
      };
    })
  ];
}
