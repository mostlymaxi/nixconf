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

  services.metrics.enable = false;

  networking.networkmanager.enable = false;
  # hard coded like a true genius (faster boot times)
  networking.interfaces.enp12s0.ipv4.addresses = [{
    address = "192.168.88.244";
    prefixLength = 24;
  }];
  networking.defaultGateway = "192.168.88.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  boot.kexec.enable = true;

  programs.steam.enable = true;

  system.stateVersion = "24.11";
}
