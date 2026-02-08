{
  config,
  lib,
  ...
}:
with lib;
{
  programs.git = mkIf config.programs.core.enable {
    enable = true;
    settings = {
      user.name = "Maxi Saparov";
      user.email = "maxi.saparov@gmail.com";
    };
  };
}
