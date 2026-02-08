{ mylib, lib, ... }:
with lib;
{
  imports = mylib.listFiles ./.;

  options = {
    desktop = {
      default = mkOption {
        type = types.enum [ ];
      };

      initial-session = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = {
    xdg.portal.enable = true;
  };
}
