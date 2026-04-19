{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  config = lib.mkIf (config.style.fonts.enable == true) {
    home.packages = with pkgs; [
      nerd-fonts.caskaydia-cove # includes ligatures <=>
      nerd-fonts.caskaydia-mono

      noto-fonts
      noto-fonts-color-emoji

      inputs.private-fonts.packages."${pkgs.stdenv.system}".codelia
      inputs.private-fonts.packages."${pkgs.stdenv.system}".tabulamore-script

    ];

    fonts.fontconfig.enable = true;
  };
}
