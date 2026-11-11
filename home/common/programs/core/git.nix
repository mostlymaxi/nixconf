{
  config,
  lib,
  ...
}:
with lib;
{
  programs.git = mkIf config.programs.core.enable {
    enable = true;
    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ecdsa.pub";
      signByDefault = true;
    };
    settings = {
      user.name = "Maxi Saparov";
      user.email = "max.saparov@gmail.com";
    };
  };
}
