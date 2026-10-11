{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
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

    # Only what cannot live in home-manager: session registration, PAM for
    # gnome-keyring, polkit policy and the system-wide portal routing.
    # Everything else is in home/nixos/desktop/niri.
    programs.niri.enable = true;
    # Route FileChooser to the gtk portal instead of Nautilus.
    programs.niri.useNautilus = false;
  };
}
