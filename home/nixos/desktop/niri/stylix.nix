{ lib, config, ... }:
with lib;
{
  config = mkIf (config.stylix.enable) {

    wayland.windowManager.niri.settings = {
      cursor.xcursor-size = mkDefault config.stylix.cursor.size;
      cursor.xcursor-theme = mkDefault config.stylix.cursor.name;
      layout.focus-ring.off = mkDefault { };
      layout.border = with config.lib.stylix.colors.withHashtag; {
        active-gradient._props = mkDefault {
          from = base08;
          to = base0C;
          angle = 45;
        };
        inactive-color = mkDefault base03;
      };
    };
  };
}
