{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{

  options = {
    games.enable = mkEnableOption "unlimited games but no games";
  };

  config = mkIf config.games.enable {
    home.packages = with pkgs; [
      prismlauncher
    ];

    programs.java.enable = true;
  };
}
