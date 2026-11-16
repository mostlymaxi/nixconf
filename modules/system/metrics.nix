{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.metrics;
  inherit (lib)
    mkIf
    mkMerge
    mkOption
    types
    ;

  hostKey = ../../secret/hosts + "/${config.networking.hostName}.pub";

  nodeJob = {
    job_name = "node";
    static_configs = [
      {
        targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        labels.instance = config.networking.hostName;
      }
    ];
    metric_relabel_configs =
      lib.optional (cfg.keep != [ ]) {
        action = "keep";
        source_labels = [ "__name__" ];
        regex = lib.concatStringsSep "|" cfg.keep;
      }
      ++ map (selector: {
        action = "drop";
        "if" = selector;
      }) cfg.drop;
  };

  snmpJob = {
    job_name = "snmp";
    metrics_path = "/snmp";
    params = {
      module = [ "if_mib" ];
      auth = [ "public_v2" ];
    };
    static_configs = lib.mapAttrsToList (name: address: {
      targets = [ address ];
      labels.instance = name;
    }) cfg.snmpDevices;
    relabel_configs = [
      {
        source_labels = [ "__address__" ];
        target_label = "__param_target";
      }
      {
        target_label = "__address__";
        replacement = "127.0.0.1:${toString config.services.prometheus.exporters.snmp.port}";
      }
    ];
    metric_relabel_configs = [
      {
        action = "keep";
        source_labels = [ "__name__" ];
        regex = "ifHC(In|Out)Octets|if(In|Out)(Errors|Discards)|ifOperStatus|ifHighSpeed";
      }
    ];
  };
in
{
  options.services.metrics = {
    enable = mkOption {
      type = types.bool;
      default = builtins.pathExists hostKey;
      description = ''
        Whether to collect this PC's metrics. On by default for a host whose
        key is in secret/hosts, because only those can decrypt the token.
      '';
    };

    interval = mkOption {
      type = types.str;
      default = "60s";
      description = ''
        How often to read the metrics. Grafana Cloud's allowance is one data point
        per series per minute; a shorter interval multiplies the usage it counts.
        Longer than 2m leaves gaps in graphs, because a series with no sample for
        five minutes is treated as gone.
      '';
    };

    collectors = mkOption {
      type = types.listOf types.str;
      default = [
        "cpu"
        "meminfo"
        "loadavg"
        "filesystem"
        "diskstats"
        "netdev"
        "pressure"
        "stat"
      ];
      example = [ "hwmon" ];
      description = ''
        The node exporter collectors to run. Only these run; the exporter's own
        default set is switched off. A collector's metrics must also be listed in
        {option}`keep` to be sent.
      '';
    };

    keep = mkOption {
      type = types.listOf types.str;
      default = [
        "node_cpu_seconds_total"
        "node_load1"
        "node_memory_(MemTotal|MemAvailable|SwapTotal|SwapFree)_bytes"
        "node_filesystem_(size|avail)_bytes"
        "node_disk_(read|written)_bytes_total"
        "node_disk_io_time_seconds_total"
        "node_network_(receive|transmit)_bytes_total"
        "node_pressure_.+"
        "node_boot_time_seconds"
      ];
      description = ''
        Metric names to send, as regular expressions matched against the whole
        name. An empty list sends everything the collectors produce (several
        hundred series per PC instead of a few dozen).
      '';
    };

    drop = mkOption {
      type = types.listOf types.str;
      default = [
        ''node_cpu_seconds_total{mode!="idle"}''
        ''{__name__=~"node_network_.+",device=~"lo|veth.*|docker.*|br-.*|virbr.*"}''
        ''{__name__=~"node_filesystem_.+",fstype=~"tmpfs|ramfs|fuse.*|overlay|squashfs"}''
        ''{__name__=~"node_filesystem_.+",mountpoint="/nix/store"}''
      ];
      description = ''
        Series to leave out, as selectors. Applied after {option}`keep`.
      '';
    };

    snmpDevices = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        router = "192.168.88.1";
      };
      description = ''
        Network devices that this PC reads over SNMP and sends metrics for, as
        name and address. A router or a switch cannot push for itself. Set this
        on one PC only. The device must allow SNMP v2c with the community
        `public` from this PC.
      '';
    };

    extraScrapeConfigs = mkOption {
      type = types.listOf (types.attrsOf types.anything);
      default = [ ];
      description = ''
        More Prometheus scrape jobs for the same agent to push, for things that
        cannot push for themselves: an SNMP exporter for a router or switch,
        another program's /metrics endpoint. {option}`keep` and {option}`drop`
        do not apply to these jobs.
      '';
    };

    grafanaCloud = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to push the metrics to Grafana Cloud.";
      };

      prometheusUrl = mkOption {
        type = types.str;
        default = "https://prometheus-prod-66-prod-us-east-3.grafana.net/api/prom/push";
        description = "The stack's Prometheus remote write endpoint.";
      };

      prometheusUsername = mkOption {
        type = types.str;
        default = "3055526";
        description = "The stack's Prometheus instance ID (a number).";
      };

      apiKeyFile = mkOption {
        type = types.str;
        default = config.age.secrets.grafana-api-key.path;
        description = ''
          File holding a Grafana Cloud access policy token with the
          `metrics:write` scope. It can stay readable by root alone: systemd
          hands it to the agent as a credential.
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.prometheus.exporters.node = {
        enable = true;
        listenAddress = "127.0.0.1";
        enabledCollectors = cfg.collectors;
        extraFlags = [ "--collector.disable-defaults" ];
      };
    }

    (mkIf cfg.grafanaCloud.enable {
      age.secrets.grafana-api-key.file = ../../secret/grafana-api-key.age;

      services.vmagent = {
        enable = true;
        remoteWrite = {
          url = cfg.grafanaCloud.prometheusUrl;
          basicAuthUsername = cfg.grafanaCloud.prometheusUsername;
          basicAuthPasswordFile = cfg.grafanaCloud.apiKeyFile;
        };
        extraArgs = [ "-httpListenAddr=127.0.0.1:8429" ];
        prometheusConfig = {
          global.scrape_interval = cfg.interval;
          scrape_configs = [
            nodeJob
          ]
          ++ lib.optional (cfg.snmpDevices != { }) snmpJob
          ++ cfg.extraScrapeConfigs;
        };
      };
    })

    (mkIf (cfg.snmpDevices != { }) {
      services.prometheus.exporters.snmp = {
        enable = true;
        listenAddress = "127.0.0.1";
        configurationPath = pkgs.runCommand "snmp.yml" { } ''
          cp ${pkgs.prometheus-snmp-exporter.src}/snmp.yml $out
        '';
      };
    })
  ]);
}
