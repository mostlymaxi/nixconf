{pkgs, lib, config, ...}: with lib; {
  options = {
    terminal = mkOption {
      type = types.enum ["fuzzel"];
    };
  };

  config = lib.mkIf (config.launcher == "fuzzel") {
    launchLauncher = "${pkgs.fuzzel}/bin/fuzzel";

    programs.fuzzel = {
      enable = true;
    };
  };
}

