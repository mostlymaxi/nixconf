{pkgs, ...}: {
  imports = [
    ../../home/core.nix
  ];

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
