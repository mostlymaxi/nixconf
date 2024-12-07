{pkgs, lib, config, niri, ...}: with lib; {
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
    };
  };
}

