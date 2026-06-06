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

  config = mkIf (config.shell.fish.enable || config.shell.default == "fish") {
    shell.exec = mkIf (config.shell.default == "fish") "${pkgs.fish}/bin/fish";
    home.sessionVariables.SHELL = mkIf (config.shell.default == "fish") "${pkgs.fish}/bin/fish";

    programs.fish = {
      enable = true;

      shellAliases = config.shell.aliases;

      functions = {
        # Skip the (heavy) greeting when re-exec'd into a `dev` shell; the
        # prompt already shows we are in a virtual environment.
        fish_greeting = ''
          if not set -q IN_NIX_SHELL
            ${config.shell.greeting}
          end
        '';
      };

      # While inside a `nix develop` shell, prefix the prompt with a [project]
      # tag (truncated if long), wrapping the existing default prompt instead
      # of replacing it.
      interactiveShellInit = ''
        functions --copy fish_prompt __default_fish_prompt
        function fish_prompt
          if set -q IN_NIX_SHELL
            set -l proj (set -q DEV_PROJECT; and echo $DEV_PROJECT; or basename $PWD)
            if test (string length -- $proj) -gt 20
              set proj (string sub -l 19 -- $proj)"…"
            end
            set_color -o brmagenta
            echo -n "[$proj] "
            set_color normal
          end
          __default_fish_prompt
        end
      '';

      plugins = mkMerge [
        ([ ])
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
