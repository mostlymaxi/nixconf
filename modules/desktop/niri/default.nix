{pkgs, ...}: {
  services.displayManager.sessionPackages = [ pkgs.niri ];

  environment.systemPackages = with pkgs; [
    wl-clipboard
    wayland-utils
    xwayland-satellite
  ];


  # ------- HACK -------
  # i want this to be a part of home manager
  # but for some reason niri is unhappy with me
  # so it needs to be here :(
  xdg.portal = {
    enable = true;

    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };
}
