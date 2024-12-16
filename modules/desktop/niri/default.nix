{pkgs, lib, config, ...}: with lib; {

  options = {
    available-desktops = mkOption {
      type = types.listOf types.enum ["niri"];
    };
  };

  config = mkIf (config.available-desktops.niri.enable) {
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
