{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/fonts
    ../../home/desktop
    ../../home/terminal
    ../../home/shell
    ../../home/programs
    ../../home/style/catppuccin
  ];
  
  desktop = "niri";
  terminal = "foot";
  shell = "fish";

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
