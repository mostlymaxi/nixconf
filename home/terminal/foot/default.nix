{pkgs, lib, config, ...}: {
  config = lib.mkIf (config.terminal == "foot") {
    programs.foot = {
      enable = true;
    };
  };
}

