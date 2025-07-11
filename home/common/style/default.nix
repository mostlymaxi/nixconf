{
  config,
  mylib,
  lib,
  ...
}:
with lib;
{
  imports = mylib.listFiles ./.;

  options = {
    style = {
      enable = mkEnableOption "all style settings";

      fonts = {
        enable = mkEnableOption "default fonts";
      };
    };
  };

  config = mkIf config.style.enable {
    style.fonts.enable = true;
  };

}
