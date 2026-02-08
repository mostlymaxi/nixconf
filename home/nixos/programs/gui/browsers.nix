{
  lib,
  config,
  username,
  ...
}: with lib; {
  config = mkIf config.programs.gui.enable {
  programs = {
    firefox = {
      enable = true;
      profiles.${username} = {};
    };
  };
  };
}
