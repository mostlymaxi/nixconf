{ pkgs, ... }:
{
  imports = [
    ../../modules/system
    ../../modules/system/metrics.nix
    ./hardware-configuration.nix
  ];

  greeter = "tuigreet";
  desktop.niri.enable = true;
  desktop.default = "niri";

  services.metrics.enable = false;

  services.monero.p2pool = {
    enable = true;
    size = "mini";
    address = "4Atjs1BtpTtFKnK6ZxF8y7bWp4kiy6eBE2F2RDGV8YXiXDUnMUMAgBmBrNczWWKgYiLSvUSEFRuidca2hRCZL7BFHzTsrkN";
  };

  networking.networkmanager.enable = false;
  # hard coded like a true genius (faster boot times)
  networking.interfaces.enp12s0.ipv4.addresses = [
    {
      address = "192.168.88.244";
      prefixLength = 24;
    }
  ];

  networking.defaultGateway = "192.168.88.1";
  networking.nameservers = [
    "1.1.1.1"
    "8.8.8.8"
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_7_1;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.kexec.enable = true;

  mdns.enable = true;

  programs.steam.enable = true;

  system.stateVersion = "26.05";
}
