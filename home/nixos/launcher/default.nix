{lib, ...}: with lib; {
  imports = [./fuzzel];

  options = {
    launcher = mkOption {
      type = types.enum [];
    };

    launchLauncher = mkOption {
      type = types.str;
    };
  };
}
