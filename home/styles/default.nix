{pkgs, lib, config, options, stylix, ...}: {
  imports = [ stylix.homeManagerModules.stylix ];
 
  stylix = {
    enable = true;
    image = ./1.png;
    polarity = "dark";
  }; 
}

