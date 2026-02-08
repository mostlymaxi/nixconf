{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{

  options = {
    terminal = {
      default = mkOption {
        type = types.enum [ "foot" ];
      };

      foot = {
        enable = mkEnableOption "foot terminal";
      };
    };
  };

  config = mkIf config.terminal.foot.enable {
    terminal.exec = mkIf (config.terminal.default == "foot") "${pkgs.foot}/bin/footclient";

    programs.foot = {
      enable = true;
      server.enable = true;

      settings = {
        csd = {
          preferred = "server";
        };

        main = {
          shell = "${config.shell.exec}";
          term = "xterm-256color";
          dpi-aware = mkForce "yes";
          pad = "5x0";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
