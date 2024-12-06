{lib, ...}: with lib; {
  imports = [./fish];

  options = {
    shell = mkOption {
      type = types.enum ["fish"];
    };
  };
}
