{ lib, mylib, ... }:
with lib;
{
  # utility function from Ryan Yin's nix config
  # to get a list of directories from a path
  imports = mylib.listFiles ./.;

  options = {
    terminal = {
      default = mkOption {
        type = types.enum [ ];
      };

      exec = mkOption {
        type = types.str;
      };
    };
  };
}
