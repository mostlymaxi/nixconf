{ pkgs, ... }:
{
  imports = [
    ../../home
  ];

  # adds a bunch of default programs
  programs.enable = true;
  # stylix config to manage color schemes + swaybg
  pretty.enable = true;

  # setting environment config
  desktop = "niri";
  terminal = "foot";
  shell = "fish";
  launcher = "fuzzel";

  programs.git = {
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
