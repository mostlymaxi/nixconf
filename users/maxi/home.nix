{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/fonts
    ../../home/desktop
  ];

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
