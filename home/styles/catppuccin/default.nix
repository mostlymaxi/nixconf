{lib, config, catppuccin, ...}: with lib; {
  imports = [ catppuccin.homeManagerModules.catppuccin ];

  options = {
    style = mkOption {
      type = types.enum ["catppuccin"];
    };
  };

  config = lib.mkIf (config.style == "catppuccin") {
    catppuccin.enable = true;
    catppuccin.flavor = "mocha";
  };
}

