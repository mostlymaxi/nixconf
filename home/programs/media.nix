{
  pkgs,
  config,
  ...
}:
# media - control and enjoy audio/video
{
  # imports = [
  # ];

  home.packages = with pkgs; [
    ffmpeg-full

    # audio control
    playerctl
    pulsemixer
    # images
    imv
  ];

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
  };
 
  services = {
    playerctld.enable = true;
  };
}
