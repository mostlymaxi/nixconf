{pkgs, lib, config, options, stylix, ...}: {
  imports = [ stylix.homeManagerModules.stylix ];
 
  stylix = {
    enable = true;
    image = ~/Downloads/1.png;
    polarity = "dark";
  }; 
}

