{
  config,
  lib,
  mylib,
  pkgs,
  ...
}:
with lib;
{

  imports = mylib.listFiles ./.;

  config = mkIf config.programs.core.enable {
    home.packages = with pkgs; [
      # misc
      libnotify
      xdg-utils
      xwayland
      vesktop
    ];

    services = {
      # notification daemon
      mako = {
        enable = true;

        settings = {
          defaultTimeout = 15000;

          margin = "24";
          padding = "8";
          borderSize = 2;
          borderRadius = 8;
          width = 300;
          height = 160;
        };
      };

      # auto mount usb drives
      udiskie.enable = true;
    };
  };
}
