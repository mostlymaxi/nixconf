{pkgs, lib, config, options, catppuccin, ...}: {
  imports = [ catppuccin.homeModules.catppuccin ];

  config = {
    catppuccin.enable = true;
  };
}

