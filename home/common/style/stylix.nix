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

  config = mkIf (config.style.enable) {
    stylix = {
      enable = true;
      autoEnable = true;

      polarity = "dark";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/pandora.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/pop.yaml";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/eldritch.yaml";

      fonts = {
        monospace = lib.mkIf config.style.fonts.enable {
          package = inputs.private-fonts.packages."${pkgs.stdenv.system}".codelia;
          name = "Codelia";
        };
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
