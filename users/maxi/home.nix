{pkgs, ...}: {
  imports = [
    ../../home
  ];
 
  programs.enable = true; 
  desktop.niri.enable = true;

  terminal = "foot";
  shell = "fish";
  launcher = "fuzzel";
  # style = "catppuccin";

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
