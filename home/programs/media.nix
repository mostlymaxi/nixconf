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
    # images
    imv

  ];
  #
  # xdg.portal = {
  #   config = {
  #     niri = {
  #       default = [
  #         "gnome"
  #       ];
  #       "org.freedesktop.impl.portal.Secret" = [
  #         "gnome-keyring"
  #       ];
  #     };
  #   };
  # };
  #
  #   extraPortals = with pkgs; [
  #     xdg-desktop-portal-gnome # for gtk
  #     # xdg-desktop-portal-kde  # for kde
  #   ];
  # };

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
 
  # services = {
  #   playerctld.enable = true;
  # };
}
