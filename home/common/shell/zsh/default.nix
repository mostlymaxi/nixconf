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
        type = types.enum [ "zsh" ];
      };

      zsh = {
        enable = mkEnableOption "zsh shell";
      };
    };
  };

  config = mkIf (config.shell.zsh.enable || config.shell.default == "zsh") {
    shell.exec = mkIf (config.shell.default == "zsh") "${pkgs.zsh}/bin/zsh";
    home.sessionVariables.SHELL = mkIf (config.shell.default == "zsh") "${pkgs.zsh}/bin/zsh";

    programs.zsh = {
      enable = true;

      shellAliases = config.shell.aliases;

      # Greeting on interactive start, skipped when re-exec'd into a `dev`
      # shell; the prompt already shows the virtual environment there.
      # While inside a `nix develop` shell, prefix the prompt with a [project]
      # tag (truncated if long), keeping the existing prompt after it.
      initContent = ''
        if [[ -z "$IN_NIX_SHELL" ]]; then
          ${config.shell.greeting}
        fi

        setopt prompt_subst
        _dev_tag() {
          [[ -z "$IN_NIX_SHELL" ]] && return
          local proj=''${DEV_PROJECT:-''${PWD:t}}
          (( ''${#proj} > 20 )) && proj=''${proj:0:19}…
          print -Pn "%B%F{magenta}[''${proj}]%f%b "
        }
        PROMPT='$(_dev_tag)'$PROMPT
      '';
    };
  };
}
