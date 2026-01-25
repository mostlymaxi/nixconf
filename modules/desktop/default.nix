{ lib, ... }:
with lib;
{
  imports = [ ./niri ];

  options = {
    available-desktops = mkOption {
      type = types.listOf (types.enum [ ]);
    };

    initial-session = mkOption {
      type = types.str;
    };
  };

  config = {
    xdg.portal.enable = true;
  };
}
