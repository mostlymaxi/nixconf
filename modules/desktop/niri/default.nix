{pkgs, lib, ...}: with lib; {

  config = mkIf desktop == "niri" {
    services.displayManager.sessionPackages = [ pkgs.niri ];

    environment.systemPackages = with pkgs; [
      wl-clipboard
      wayland-utils
      xwayland-satellite
    ];

    xdg.portal = {
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

      config = {
        niri.default = "gnome";
      };
    };
  };
}
