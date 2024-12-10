{pkgs, lib, config, options, stylix, ...}: {
  imports = [ stylix.homeManagerModules.stylix ];

      systemd.user.services."swaybg" = {
        Unit = {
          Description = "wallpapers! brought to you by stylix! :3";
          PartOf = ["graphical-session.target"];
          After = ["graphical-session.target"];
        };
        Install.WantedBy = ["graphical-session.target"];
        Service = {
          ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${config.stylix.image}";
          Restart = "on-failure";
        };
      };
 
  stylix = {
    enable = true;
    autoEnable = true;

    # image = ./1.png;

    # image = pkgs.fetchurl {
    #     url = "https://w.wallhaven.cc/full/3z/wallhaven-3z97yd.jpg";
    #     hash = "sha256-Dc/VgWkzlhdLaLzZAJe76GfoyECabTIqUilDNbd+dYk=";
    # };

    image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/r2/wallhaven-r27kwq.jpg";
        hash = "sha256-NcHYoGCORoMs+I0jW5Z6XR07X8Iizfh7Z1gLULlepe0=";
    };



    polarity = "dark";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/pandora.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/pop.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/jabuti.yaml";

    # this must be a multiple of 3 for gtk-3.0
    # apps to understand this properly for some
    # very strange reason
    cursor.size = 33;

    fonts = {
      monospace.package = pkgs.cascadia-code;
      monospace.name = "Cascadia Mono";
      sansSerif.package = pkgs.noto-fonts;
      sansSerif.name = "Noto Sans";
      serif.package = pkgs.noto-fonts;
      serif.name = "Noto Sans";

      sizes = {
        applications = 12;
        desktop = 12;
        popups = 16;
        terminal = 16;
      };
    };
  };
}

