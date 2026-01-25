{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  options = {
    terminal = mkOption {
      type = types.enum [ "foot" ];
    };
  };

  config = lib.mkIf (config.terminal == "foot") {
    launchTerminal = "${pkgs.foot}/bin/footclient";
    # launchTerminal = "footclient";

    programs.foot = {
      enable = true;

      server.enable = true;

      settings = {
        csd = {
          preferred = "server";
        };

        main = {
          shell = "${config.launchShell}";
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
