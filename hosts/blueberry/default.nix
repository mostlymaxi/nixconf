{ hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
  };

  system = {
    stateVersion = "26.05";
  };
}
