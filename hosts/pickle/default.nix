{ ... }:

{
  imports = [
    ../../modules/system
    ../../modules/greeter
    ../../modules/desktop

    ./hardware-configuration.nix
  ];

  greeter = "tuigreet";
  desktop.niri.enable = true;
  desktop.default = "niri";

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  programs.steam.enable = true;

  system.stateVersion = "24.11";
}
