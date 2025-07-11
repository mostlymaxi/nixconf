{ hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system
  ];

  host.is_headless = true;

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;
  };

  system = {
    stateVersion = "25.11";
  };
}
