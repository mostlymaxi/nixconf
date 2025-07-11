{
  lib,
  mylib,
  config,
  ...
}:
with lib;
{
  imports = mylib.listFiles ./.;

  options = {
    programs = {
      enable = mkEnableOption "all programs";
      core.enable = mkEnableOption "core programs";
      gui.enable = mkEnableOption "gui programs";
    };
  };

  config = mkIf config.programs.enable {
    programs.core.enable = true;
    programs.gui.enable = true;
  };

}
