{lib, ...}: with lib; {
  imports = [./niri];

  options = {
    available-desktops = mkOption {
      type = types.listOf types.enum [];
    };
  };

  config = {
    xdg.portal.enable = true;
  };
}
