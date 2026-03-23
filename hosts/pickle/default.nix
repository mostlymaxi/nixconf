{ ... }:

{
  imports = [
    ../../modules/system
    ../../modules/system/metrics.nix
    ../../modules/greeter
    ../../modules/desktop

    ./hardware-configuration.nix
  ];

  greeter = "tuigreet";
  desktop.niri.enable = true;
  desktop.default = "niri";

  services.metrics.enable = true;
  services.metrics.grafanaCloud = {
    enable = true;
    prometheusUrl = "https://prometheus-prod-66-prod-us-east-3.grafana.net/api/prom/push";
    prometheusUsername = "3055526";
    apiKeyFile = "/run/secrets/grafana_api_key";
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kexec.enable = true;

  programs.steam.enable = true;

  system.stateVersion = "24.11";
}
