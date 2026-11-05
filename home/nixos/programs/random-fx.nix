{
  lib,
  osConfig,
  inputs,
  ...
}:
{
  imports = [ inputs.random-fx.homeModules.default ];

  # colors follow stylix automatically
  programs.random-fx = lib.mkIf osConfig.desktop.niri.enable {
    enable = true;
    settings = {
      # border box (x y w h) of the waybar clock pill, for the half-hourly chime
      clock = "2291 1395 261 41";
    };
  };
}
