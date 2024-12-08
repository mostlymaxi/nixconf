{config, pkgs, ...}: {
  xdg = {
    enable = true;
  #   cacheHome = config.home.homeDirectory + "/.local/cache";

  #   mimeApps = {
  #     enable = true;
  #   };

    portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-gnome pkgs.gnome-keyring ];
    };

  #   userDirs = {
  #     enable = true;
  #     createDirectories = true;
  #     extraConfig = {
  #       XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
  #     };
  #   };
  };
}
