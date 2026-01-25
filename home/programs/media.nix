{
  pkgs,
  inputs,
  ...
}:
# Media - control and enjoy audio/video
{
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

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
    spicetify = {
      enable = true;
    };
  };

  # playback control
  services = {
    playerctld.enable = true;
  };
}
