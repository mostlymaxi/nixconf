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
    ];

    programs.vesktop.enable = true;

    services = {
      # notification daemon
      mako = {
        enable = true;

        settings = {
          default-timeout = 15000;

          margin = "24";
          padding = "8";
          border-size = 2;
          border-radius = 8;
          width = 300;
          height = 160;
        };
      };

      # auto mount usb drives
      udiskie.enable = true;
    };
  };
}
