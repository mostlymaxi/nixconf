{
  pkgs,
  spicetify-nix,
  ...
}:
# media - control and enjoy audio/video
{
  imports = [
    spicetify-nix.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    ffmpeg-full

    # audio control
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

    spicetify = {
      enable = true;
    };
  };
 
  # services = {
  #   playerctld.enable = true;
  # };
}
