{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/desktop/niri
  ];

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
