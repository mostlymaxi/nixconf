{
  pkgs,
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
        default = "sh";
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
        default = "";
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

    # Shell-agnostic scripts. `dev` drops into a `nix develop` shell using the
    # configured interactive shell (not bash), tagging it so the prompt can
    # show which project's virtual environment we are in.
    home.packages = [
      (pkgs.writeShellScriptBin "dev" ''
        export DEV_PROJECT="$(basename "$PWD")"
        exec nix develop "$@" --command ${config.shell.exec}
      '')
    ];
  };
}
