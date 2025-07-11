{ pkgs, lib, config, ... }: with lib; {
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

    programs.fish = {
      enable = true;

      shellAliases = config.shell.aliases;

      functions = {
        fish_greeting = config.shell.greeting;
      };

      plugins = mkMerge [
        ([ ])
        (mkIf (config.programs.core.enable) [{ name = "grc"; src = pkgs.fishPlugins.grc.src; }])
      ];

    };
  };
}


