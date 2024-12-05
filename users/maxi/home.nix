{pkgs, ...}: {
  imports = [
    ../../home/core.nix
    ../../home/desktop/plasma
  ];

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
