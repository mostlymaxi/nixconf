{pkgs, lib, config, niri, ...}: {
  imports = [ niri.homeModules.niri ]; 
  programs.niri.package = pkgs.niri;

  programs.niri = lib.mkIf config.desktop == "niri" {
    enable = true;
    
    # settings.binds = with config.lib.niri.actions; {
    #   "Mod+Return".action = spawn "alacritty";
    # };
  };

  programs.alacritty.enable = true;
}

