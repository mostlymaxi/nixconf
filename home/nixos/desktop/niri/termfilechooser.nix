{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib;
let
  termfilechooser = pkgs.xdg-desktop-portal-termfilechooser;
in
{
  config = mkIf osConfig.desktop.niri.enable {
    programs.yazi.enable = true;

    # The per-user portals.conf wins over the one programs.niri writes to
    # /etc/xdg, so FileChooser can be rerouted here without touching the OS.
    xdg.configFile."xdg-desktop-portal/niri-portals.conf".text = ''
      [preferred]
      default=gnome;gtk
      org.freedesktop.impl.portal.FileChooser=termfilechooser
      org.freedesktop.impl.portal.Access=gtk
      org.freedesktop.impl.portal.Notification=gtk
      org.freedesktop.impl.portal.Secret=gnome-keyring
    '';

    # The shipped wrappers run `$TERMCMD <picker> <args>`, so the terminal has
    # to accept a trailing command without -e. foot does.
    xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
      [filechooser]
      cmd=${termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
      env=TERMCMD=${pkgs.foot}/bin/foot --app-id termfilechooser
    '';

    wayland.windowManager.niri.settings = {
      # GTK and Firefox only use the portal file chooser when asked.
      environment.GTK_USE_PORTAL = "1";

      _children = [
        {
          window-rule = {
            _children = [ { match._props.app-id = "^termfilechooser$"; } ];
            open-floating = true;
          };
        }
      ];
    };
  };
}
