{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/system
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kexec.enable = true;

  system.stateVersion = "26.05";
}
