{mylib, lib, ...}: with lib; {
  imports = mylib.listFiles ./.;

  options = {
    available-desktops = mkOption {
      type = types.listOf (types.enum []);
    };

    initial-session = mkOption {
      type = types.str;
    };
  };

  config = {
    xdg.portal.enable = true;
  };
}
