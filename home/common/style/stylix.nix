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

  config = mkMerge [
    {
      # nixpkgs.overlays is ignored under home-manager.useGlobalPkgs, so the
      # overlay targets (gtksourceview, nixos-icons) never applied anyway and
      # defining them there will soon become an eval error; the default is not
      # gated on stylix.enable, so this must be set outside the mkIf below
      stylix.overlays.enable = false;
    }

    (mkIf (config.style.enable) {
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
            # stylix scales terminal pt by 4/3 on darwin (96 -> 72 dpi compensation),
            # which overshoots on retina displays; 12 * 4/3 lands back at 16pt
            terminal = if pkgs.stdenv.hostPlatform.isDarwin then 14 else 16;
          };
        };
      };
    })
  ];
}
