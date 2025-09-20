{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  options = {
    shell = {
      default = mkOption {
        type = types.enum [ "fish" ];
      };

      fish = {
        enable = mkEnableOption "fish shell";
      };
    };
  };

  config = mkIf config.shell.fish.enable {
    shell.exec = mkIf (config.shell.default == "fish") "${pkgs.fish}/bin/fish";
    home.sessionVariables.SHELL = mkIf (config.shell.default == "fish") "${pkgs.fish}/bin/fish";
    home.file.".bash_profile".text = mkIf (config.shell.default == "fish") ''
      # If not running interactively, don't do anything
      case $- in
          *i*) ;;
            *) exit 0;;
      esac

      if [ -n $FORCE_SHELL_ONCE ]; then
        unset FORCE_SHELL_ONCE
        exec ${config.shell.exec}
      fi
    '';

    programs.fish = {
      enable = true;

      shellAliases = config.shell.aliases // {
        dev = "nix develop -c fish -C 'set hydro_color_pwd magenta'";
      };

      functions = {
        fish_greeting = config.shell.greeting;
      };

      interactiveShellInit = ''
        set -g hydro_color_pwd $fish_color_cwd
      '';

      plugins = mkMerge [
        [
          {
            name = "hydro";
            src = pkgs.fishPlugins.hydro.src;
          }
        ]
        (mkIf (config.programs.core.enable) [
          {
            name = "grc";
            src = pkgs.fishPlugins.grc.src;
          }
        ])
      ];

    };
  };
}
