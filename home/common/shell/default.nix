{
  lib,
  mylib,
  config,
  ...
}:
with lib;
{
  imports = mylib.listFiles ./.;

  options = {
    shell = {
      default = mkOption {
        type = types.enum [ "none" ];
        default = "none";
      };

      exec = mkOption {
        type = types.str;
        default = "";
      };

      aliases = mkOption {
        type = types.attrsOf types.str;
        default = {
          ls = "ls -la";
          please = "sudo";
        };
      };

      greeting = mkOption {
        type = types.str;
      };
    };
  };

  config = {
    shell = {
      aliases = mkIf config.programs.core.enable {
        ls = "eza -la";
        cat = "bat";
        ff = "fastfetch";
        please = "sudo";
      };

      greeting = mkIf config.programs.core.enable "fastfetch";
    };
  };
}
