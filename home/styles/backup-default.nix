{lib, ...}: with lib; {
  imports = [./catppuccin];

  options = {
    style = mkOption {
      type = types.enum [];
    };
  };
}
