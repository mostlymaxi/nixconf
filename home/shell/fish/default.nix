{pkgs, lib, config, niri, ...}: {
  config = lib.mkIf (config.shell == "fish") {
    programs.fish = {
      enable = true;
    };
  };
}

