{
  lib,
  config,
  osConfig,
  pkgs,
  ...
}:
with lib;
{
  imports = [
    ./stylix.nix
  ];

  config = mkIf osConfig.desktop.niri.enable {
    home.packages = with pkgs; [
      wl-clipboard
      wayland-utils
    ];

    # Nothing else in the config provides a polkit agent.
    services.hyprpolkitagent.enable = true;

    wayland.windowManager.niri =
      let
        gaps = 16;
        bar-height = 45;
      in
      {
        enable = true;

        # programs.niri (nixpkgs) already installs the systemd units and
        # portals system-wide; don't install a second copy per user.
        systemd.enable = false;
        portalPackage = null;

        settings = {
          prefer-no-csd = { };
          hotkey-overlay.skip-at-startup = { };
          cursor.hide-after-inactive-ms = 3000;

          environment.DISPLAY = ":0";

          # niri's built-in defaults are off; its default config.kdl turns
          # these on, and so did niri-flake.
          input.touchpad = {
            tap = { };
            natural-scroll = { };
          };

          layout = {
            inherit gaps;
            always-center-single-column = { };
          };

          _children = [
            {
              window-rule = {
                clip-to-geometry = true;
                geometry-corner-radius = [
                  6.0
                  6.0
                  6.0
                  6.0
                ];
                max-height = 1080 - 2 * gaps - bar-height;
              };
            }
            {
              window-rule = {
                _children = [ { match._props.app-id = "^foot|footclient$"; } ];
                default-column-width.proportion = 1.0 / 2.0;
                open-maximized = true;
                opacity = 0.8;
              };
            }
            {
              window-rule = {
                _children = [ { match._props.app-id = "ghostty$"; } ];
                default-column-width.proportion = 1.0 / 2.0;
                open-maximized = true;
                opacity = 0.8;
              };
            }
            {
              window-rule = {
                _children = [ { match._props.app-id = "^firefox$"; } ];
                border.active-gradient._props = {
                  from = "orange";
                  to = "red";
                  angle = 45;
                };
              };
            }
            {
              window-rule = {
                _children = [ { match._props.app-id = "obs"; } ];
                block-out-from = "screencast";
              };
            }
            {
              window-rule = {
                _children = [ { match._props.app-id = "satty"; } ];
                open-fullscreen = true;
              };
            }
          ];

          binds = {
            "Mod+Shift+Slash".show-hotkey-overlay = { };
            "Mod+Return".spawn = [ config.terminal.exec ];
            "Mod+D".spawn = [ config.launcher.exec ];
            "Mod+Space".toggle-overview = { };

            "Mod+P".screenshot._props.show-pointer = false;
            "Mod+Control+P".spawn = [
              "bash"
              "-c"
              "grim - | satty -f -"
            ];
            "Mod+Shift+P".screenshot-window = { };

            "Mod+Q".close-window = { };
            "Mod+Shift+E".quit._props.skip-confirmation = true;

            "Mod+H".focus-column-left = { };
            "Mod+L".focus-column-right = { };
            "Mod+K".focus-window-up = { };
            "Mod+J".focus-window-down = { };

            "Mod+Shift+H".consume-or-expel-window-left = { };
            "Mod+Shift+L".consume-or-expel-window-right = { };
            "Mod+Shift+K".move-window-up-or-to-workspace-up = { };
            "Mod+Shift+J".move-window-down-or-to-workspace-down = { };

            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;

            "Mod+Equal".set-column-width = "+10%";
            "Mod+Minus".set-column-width = "-10%";

            "Mod+Shift+Equal".set-window-height = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";

            "Mod+R".switch-preset-column-width = { };
            "Mod+F".maximize-column = { };
            "Mod+Shift+F".fullscreen-window = { };
            "Mod+C".center-column = { };
            "Mod+Shift+C".center-window = { };
          };
        };
      };
  };
}
