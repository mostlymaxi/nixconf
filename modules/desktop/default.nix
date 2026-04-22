{ mylib, lib, config, ... }:
with lib;
{
  imports = mylib.listFiles ./.;

  options = {
    desktop = {
      default = mkOption {
        type = types.enum [ "none" ];
        default = "none";
      };

      initial-session = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = mkIf (config.desktop.default != "none") {
    xdg.portal.enable = true;
  };
}
