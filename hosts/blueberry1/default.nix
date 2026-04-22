{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../modules/system
  ];

  # TODO: configure boot loader
  # EFI:
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  # Raspberry Pi / ARM:
  # boot.loader.grub.enable = false;
  # boot.loader.generic-extlinux-compatible.enable = true;

  boot.kexec.enable = true;

  system.stateVersion = "26.05";
}
