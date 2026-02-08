{
  config,
  lib,
  ...
}:
with lib;
{
  programs.git = mkIf config.programs.core.enable {
    enable = true;
    userName = "Maxi Saparov";
    userEmail = "maxi.saparov@gmail.com";
  };
}
