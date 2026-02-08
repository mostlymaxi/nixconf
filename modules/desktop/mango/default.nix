{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{

  imports = [
    inputs.mango.nixosModules.mango
  ];

  options = {
    desktop = {
      default = mkOption {
        type = types.enum [ "mango" ];
      };

      mango = {
        enable = mkEnableOption "mango desktop environment";
      };
    };
  };

  config = mkIf config.desktop.mango.enable {
    desktop."initial-session" = mkIf (config.desktop.default == "mango") "${pkgs.mangowc}/bin/mango";
    programs.mango.enable = true;

    services.displayManager.sessionPackages = [ pkgs.niri ];
  };
}
