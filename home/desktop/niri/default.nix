{pkgs, lib, config, niri, ...}: {
  imports = [ niri.homeModules.niri ]; 
  
  config = lib.mkIf (config.desktop == "niri") {
  programs.niri.package = pkgs.niri;

  programs.niri = {
    enable = true;
    
    # settings.binds = with config.lib.niri.actions; {
    #   "Mod+Return".action = spawn "alacritty";
    # };
  };

  programs.alacritty.enable = true;
  };
}

