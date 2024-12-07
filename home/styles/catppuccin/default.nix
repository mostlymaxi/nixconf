{pkgs, lib, config, options, catppuccin, ...}: {
  imports = [ catppuccin.homeManagerModules.catppuccin ];

  config = {
    catppuccin.enable = true;
    catppuccin.flavor = "mocha";
  };
}

