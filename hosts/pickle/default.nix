{ ... }:

{
  imports = [
    ../../modules/system
    ../../modules/greeter
    ../../modules/desktop
    ../../modules/services/minecraft-server.nix

    ./hardware-configuration.nix
  ];

  services.minecraft-simple.enable = true;

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
