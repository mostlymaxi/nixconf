{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
{
  imports = [ inputs.stylix.homeModules.stylix ];

  options = {
    pretty.enable = mkEnableOption "pretty DE with stylix + swaybg";
  };

  config = mkIf (config.pretty.enable) {
    systemd.user.services."swaybg" = {
      Unit = {
        Description = "wallpapers! brought to you by stylix! :3";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${lib.getExe pkgs.swaybg} -m fill -i ${config.stylix.image}";
        Restart = "on-failure";
      };
    };

    stylix = {
      enable = true;
      autoEnable = true;

      # gay (straight)
      image = pkgs.fetchurl {
        url = "https://w.wallhaven.cc/full/3z/wallhaven-3z97yd.jpg";
        hash = "sha256-Dc/VgWkzlhdLaLzZAJe76GfoyECabTIqUilDNbd+dYk=";
      };

      ### cityscape laptop
      # image = pkgs.fetchurl {
      #   url = "https://4kwallpapers.com/images/wallpapers/lofi-room-cityscape-urban-3840x2160-14880.jpg";
      #   hash = "sha256-chYF50xJYWpdnV+tTp9b0VgjVXrBl8L3JjEiNbVqOZc=";
      # };

      # Coca Cola Anime Girl
      # image = pkgs.fetchurl {
      #   url = "https://w.wallhaven.cc/full/r2/wallhaven-r27kwq.jpg";
      #   hash = "sha256-NcHYoGCORoMs+I0jW5Z6XR07X8Iizfh7Z1gLULlepe0=";
      # };

      # DanDanDan
      # image = pkgs.fetchurl {
      #     url = "https://w.wallhaven.cc/full/yx/wallhaven-yxd17l.png";
      #     hash = "sha256-nmBdaoYEb09MMy25IKNGDMsbL/8ldhhgWcg1v9aakuI=";
      # };
      #

      polarity = "dark";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/pandora.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/pop.yaml";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/eldritch.yaml";

      # this must be a multiple of 3 for gtk-3.0
      # apps to understand this properly for some
      # very strange reason
      # cursor.size = 32;
      cursor = {
        size = 32;
        package = pkgs.simp1e-cursors;
        name = "Simp1e-Adw-Dark";
      };

      fonts = {
        monospace.package = pkgs.nerd-fonts.caskaydia-cove;
        monospace.name = "CaskaydiaCove NFM";
        sansSerif.package = pkgs.noto-fonts;
        sansSerif.name = "Noto Sans";
        serif.package = pkgs.noto-fonts;
        serif.name = "Noto Sans";

        sizes = {
          applications = 12;
          desktop = 12;
          popups = 12;
          terminal = 16;
        };
      };
    };
  };
}
