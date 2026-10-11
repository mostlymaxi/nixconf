{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  spotify-notify = pkgs.writeShellApplication {
    name = "spotify-notify";
    runtimeInputs = with pkgs; [
      playerctl
      libnotify
      curl
    ];
    text = builtins.readFile ./spotify-notify.sh;
  };
in
# Media - control and enjoy audio/video
{
  imports = [
    inputs.spicetify.homeManagerModules.default
  ];

  config = mkIf config.programs.gui.enable {

    # Media packages
    home.packages = with pkgs; [
      # utils
      ffmpeg-full
      playerctl
      pavucontrol
      imv
      grim # wayland screenshots - needed for satty
      satty # screenshot annotator

      # misc
      cava
      krita
    ];

    # Media programs we want to manage w/ HM
    programs = {
      obs-studio = {
        enable = true;

        plugins = with pkgs.obs-studio-plugins; [
          wlrobs
          obs-vaapi
          obs-backgroundremoval
          obs-pipewire-audio-capture
        ];
      };

      # pretty spotify managed by stylix
      spicetify = lib.mkIf (pkgs.stdenv.hostPlatform.system != "aarch64-linux") {
        enable = true;
      };
    };

    # playback control
    services = {
      playerctld.enable = true;
    };

    systemd.user.services.spotify-notify = {
      Unit = {
        Description = "now-playing notifications for spotify";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = lib.getExe spotify-notify;
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };

  };
}
