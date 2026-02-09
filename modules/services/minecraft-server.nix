{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.minecraft-simple;
in
{
  options.services.minecraft-simple = {
    enable = mkEnableOption "Simple Minecraft server systemd service";
  };

  config = mkIf cfg.enable {
    systemd.services.minecraft-server = {
      description = "Minecraft Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = config.users.users.maxi.name;
        WorkingDirectory = "/home/maxi/minecraft";
        Restart = "on-failure";
        RestartSec = 30;
        ExecStart = "/home/maxi/minecraft/startserver.sh";
        Environment = "PATH=${
          lib.makeBinPath [
            pkgs.jdk21_headless
            pkgs.wget
            pkgs.curl
            pkgs.coreutils
          ]
        }";
      };
    };
  };
}
