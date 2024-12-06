{lib, ...}: {
  imports = [./niri];

  options = {
  desktop = mkOption {
    type = types.enum ["niri"];
  };
  };
}
