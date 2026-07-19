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
        type = types.enum [ "nu" ];
      };

      nu = {
        enable = mkEnableOption "nushell";
      };
    };
  };

  config = mkIf (config.shell.nu.enable || config.shell.default == "nu") {
    shell.exec = mkIf (config.shell.default == "nu") "${pkgs.nushell}/bin/nu";
    home.sessionVariables.SHELL = mkIf (config.shell.default == "nu") "${pkgs.nushell}/bin/nu";

    programs.nushell = {
      enable = true;

      shellAliases = config.shell.aliases;

      settings.show_banner = false;

      # Greeting on interactive start, skipped when re-exec'd into a `dev`
      # shell; the prompt already shows the virtual environment there.
      # While inside a `nix develop` shell, prefix the prompt with a [project]
      # tag (truncated if long), wrapping the existing default prompt instead
      # of replacing it.
      extraConfig = ''
        if "IN_NIX_SHELL" not-in $env {
          ${config.shell.greeting}
        }

        let __default_prompt = $env.PROMPT_COMMAND?
        $env.PROMPT_COMMAND = {||
          let base = if ($__default_prompt | describe) == "closure" {
            do $__default_prompt
          } else if ($__default_prompt | describe) == "string" {
            $__default_prompt
          } else {
            ""
          }
          if "IN_NIX_SHELL" in $env {
            let proj = $env.DEV_PROJECT? | default ($env.PWD | path basename)
            let proj = if ($proj | str length) > 20 {
              ($proj | str substring 0..18) + "…"
            } else {
              $proj
            }
            $"(ansi magenta_bold)[($proj)] (ansi reset)($base)"
          } else {
            $base
          }
        }
      '';
    };
  };
}
