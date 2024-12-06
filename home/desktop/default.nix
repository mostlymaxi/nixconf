{lib, ...}: with lib; {
  imports = [./niri];

  options = {
    desktop = mkOption {
      type = types.enum ["niri"];
    };
    
    startDesktop = mkOption {
      type = types.str;
    };
  };
}
