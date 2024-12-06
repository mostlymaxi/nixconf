{lib, ...}: with lib; {
  imports = [./foot];

  options = {
    terminal = mkOption {
      type = types.enum ["foot"];
    };
  };
}
