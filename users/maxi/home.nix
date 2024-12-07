{pkgs, ...}: {
  imports = [
    ../../home
  ];
 
  programs.enable = true; 

  desktop = "niri";
  terminal = "foot";
  shell = "fish";
  style = "catppuccin";

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
