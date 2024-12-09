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

  xdg.portal = {
    enable = true;

    config = {
      common = {
        default = [
          "gnome"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
    };

    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome # for gtk
      # xdg-desktop-portal-kde  # for kde
    ];
  };

  programs = {
    obs-studio = {
      enable = true;

      plugins = with pkgs.obs-studio-plugins; [
        # wlrobs
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
