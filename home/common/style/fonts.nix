{
  pkgs,
  lib,
  config,
  private-fonts,
  ...
}:
{

  # options = {
  #   style = {
  #     fonts = {
  #       default = "Caskaydia";
  #     };
  #   };
  # };

  config = lib.mkIf (config.style.fonts.enable == true) {
    home.packages = with pkgs; [
      nerd-fonts.caskaydia-cove # includes ligatures <=>
      nerd-fonts.caskaydia-mono

      noto-fonts
      noto-fonts-emoji

      private-fonts.packages."${pkgs.system}".codelia
      private-fonts.packages."${pkgs.system}".tabulamore-script

    ];

    fonts.fontconfig.enable = true;
  };
}
