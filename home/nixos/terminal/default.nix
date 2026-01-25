{lib, ...}: with lib; {
  imports = [./foot];

  options = {
    terminal = mkOption {
      type = types.enum [];
    };

    launchTerminal = mkOption {
      type = types.str;
    };
  };
}
