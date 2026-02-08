{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{

  imports = [
    inputs.niri.nixosModules.niri
  ];

  options = {
    desktop = {
      default = mkOption {
        type = types.enum [ "niri" ];
      };

      niri = {
        enable = mkEnableOption "niri desktop environment";
      };
    };
  };

  config = mkIf config.desktop.niri.enable {
    desktop."initial-session" = mkIf (config.desktop.default == "niri") "${pkgs.niri}/bin/niri-session";
    programs.niri.enable = true;

    services.displayManager.sessionPackages = [ pkgs.niri ];

    environment.systemPackages = with pkgs; [
      wl-clipboard
      wayland-utils
      xwayland-satellite
    ];

    # xdg.portal = {
    #   extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    #
    #   config = {
    #     niri.default = "gnome";
    #   };
    # };
  };
}
