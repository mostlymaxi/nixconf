{ mylib, lib, ... }:
with lib;
{
  imports = mylib.listFiles ./.;

  options = {
    greeter = mkOption {
      type = types.enum [ ];
    };
  };
}
