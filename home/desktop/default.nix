{lib, ...}: with lib; {
  imports = [./niri];

  options = {
    desktop = mkIf (osConfig.desktop.niri) mkOption {
      type = types.enum ["niri"];
    };
    
    startDesktop = mkOption {
      type = types.str;
    };
  };
}
