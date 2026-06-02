{
  config,
  lib,
  ...
}:
with lib;
{
  programs.claude-code = mkIf config.programs.core.enable {
    enable = true;
  };
}
