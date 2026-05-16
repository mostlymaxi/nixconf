{
  config,
  lib,
  ...
}:
with lib;
{
  programs.gh = mkIf config.programs.core.enable {
    enable = true;
  };
}
