{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/fonts
    ../../home/desktop
    ../../home/shell
    ../../home/programs
  ];
  
  desktop = "niri";
  shell = "fish";

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
