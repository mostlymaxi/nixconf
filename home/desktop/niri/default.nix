{pkgs, lib, config, options, niri, ...}: {
  imports = [ niri.homeModules.niri ];

  config = lib.mkIf (config.desktop == "niri") {
    startDesktop = "niri";

    programs.niri.package = pkgs.niri;

    programs.niri = {
      enable = true;
      
      settings.binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "${config.terminal}";
      };
    };
  };
}

