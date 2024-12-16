{lib, ...}: with lib; {
  imports = [./niri];

  xdg.portal.enable = true;

  options.desktop = {
    niri.enable = mkEnableOption "Niri";
  };
}
