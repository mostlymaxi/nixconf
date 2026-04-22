{ lib, config, ... }:
with lib;
{
  options.mdns.enable = mkEnableOption "mDNS discovery and broadcasting via Avahi";

  config = mkIf config.mdns.enable {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
  };
}
