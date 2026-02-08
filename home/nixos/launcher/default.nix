{ lib, ... }:
with lib;
{
  imports = [ ./fuzzel ];

  options = {
    launcher = {
      default = mkOption {
        type = types.enum [ "none" ];
        default = "none";
      };

      exec = mkOption {
        type = types.str;
      };
    };
  };
}
