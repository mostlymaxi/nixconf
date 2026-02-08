{
  lib,
  config,
  ...
}:
with lib;
{
  options = {
    launcher = {
      default = mkOption {
        type = types.enum [ "fuzzel" ];
      };
    };
  };

  config = lib.mkIf (config.launcher.default == "fuzzel") {
    launcher.exec = "fuzzel";

    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          terminal = "${config.terminal.exec}";
          font = mkForce "${config.stylix.fonts.monospace.name}:size=20";
        };
      };
    };
  };
}
