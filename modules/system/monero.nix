{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.monero;
in
{
  options.services.monero = {
    p2pool = {
      enable = mkEnableOption "P2Pool mining";
      address = mkOption {
        type = types.str;
        description = "Monero wallet address for mining rewards";
      };
      size = mkOption {
        type = types.enum [
          "default"
          "mini"
          "nano"
        ];
        default = "default";
        description = "P2Pool sidechain size";
      };
      xmrig = mkOption {
        type = types.bool;
        default = true;
        description = "Use XMRig instead of built-in miner for better hashrate";
      };
    };
  };

  config = mkIf cfg.p2pool.enable {
    boot.kernel.sysctl = {
      "vm.nr_hugepages" = 3072;
    };

    powerManagement.cpuFreqGovernor = "performance";

    services.monero = {
      enable = true;

      priorityNodes = [
        "p2pmd.xmrvsbeast.com:18080"
        "nodes.hashvault.pro:18080"
      ];

      limits = {
        upload = -1;
        download = -1;
        threads = 0;
        syncSize = 0;
      };

      extraConfig = ''
        zmq-pub=tcp://127.0.0.1:18083
        out-peers=32
        in-peers=64
        enforce-dns-checkpointing=1
        enable-dns-blocklist=1
      '';
    };

    networking.firewall.allowedTCPPorts = [
      18080 # monero p2p
      18081 # monero rpc
      37889 # p2pool default
      37888 # p2pool mini
      37890 # p2pool nano
    ];

    users.users.p2pool = {
      isSystemUser = true;
      group = "p2pool";
      home = "/var/lib/p2pool";
      createHome = false;
    };

    users.groups.p2pool = { };

    systemd.services.p2pool = {
      description = "P2Pool Monero Mining";
      after = [
        "network.target"
        "monero.service"
      ];
      requires = [ "monero.service" ];
      serviceConfig = {
        Type = "simple";
        User = "p2pool";
        Group = "p2pool";
        StateDirectory = "p2pool";
        ExecStart = "${pkgs.p2pool}/bin/p2pool --host 127.0.0.1 --wallet ${cfg.p2pool.address} --data-dir /var/lib/p2pool ${
          (
            if cfg.p2pool.size == "mini" then
              "--mini"
            else if cfg.p2pool.size == "nano" then
              "--nano"
            else
              ""
          )
        }";
        Restart = "on-failure";
        RestartSec = 30;
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

    environment.systemPackages = [ pkgs.p2pool ] ++ optionals cfg.p2pool.xmrig [ pkgs.xmrig ];

    systemd.services.xmrig = mkIf cfg.p2pool.xmrig {
      description = "XMRig Miner for P2Pool";
      after = [
        "network.target"
        "p2pool.service"
      ];
      requires = [ "p2pool.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        User = "p2pool";
        Group = "p2pool";
        ExecStart = "${pkgs.xmrig}/bin/xmrig -o 127.0.0.1:3333";
        Restart = "on-failure";
        RestartSec = 30;
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };
  };
}
