{pkgs, osConfig, ...}: {
  imports = [
    ../../home
  ];
 
  programs.enable = true; 

  desktop = "niri";
  osConfig.services.displayManager.sessionPackages = [ pkgs.niri ];
  terminal = "foot";
  shell = "fish";
  launcher = "fuzzel";
  # style = "catppuccin";

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
