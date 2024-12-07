{lib, config, catppuccin, ...}: with lib; {
  imports = [ catppuccin.homeManagerModules.catppuccin ];

  options = {
    style = mkOption {
      type = types.enum ["catppuccin"];
    };
  };

  config = lib.mkIf (config.style == "catppuccin") {
    # gtk.catppuccin.enable = true; # deprecated
    catppuccin.enable = true;
    catppuccin.flavor = "mocha";
  };
}

