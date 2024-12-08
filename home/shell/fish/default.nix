{pkgs, lib, config, ...}: with lib; {
  options = {
    shell = mkOption {
      type = types.enum [ "fish" ];
    };
  };

  config = mkIf (config.shell == "fish") {
    launchShell = "${pkgs.fish}/bin/fish";

    programs.fish = {
      enable = true;
      shellAliases = config.shellAliases;
      functions = {
        fish_greeting = "greeting";
      };

      plugins = mkMerge [
         ([])
	 (mkIf (config.programs.enable) [{ name = "grc"; src = pkgs.fishPlugins.grc.src; }])
      ];
      
    };
  };
}

