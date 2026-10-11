{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  options = {
    desktop = {
      default = mkOption {
        type = types.enum [ "niri" ];
      };

      niri = {
        enable = mkEnableOption "niri desktop environment";
      };
    };
  };

  config = mkIf config.desktop.niri.enable {
    desktop."initial-session" = mkIf (config.desktop.default == "niri") "${pkgs.niri}/bin/niri-session";

    programs.niri.enable = true;
    programs.niri.useNautilus = false;

    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-termfilechooser ];
  };
}
