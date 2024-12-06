{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/fonts
    ../../home/desktop
    ../../home/shell
  ];
  
  desktop = "niri";
  shell = "fish";

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
