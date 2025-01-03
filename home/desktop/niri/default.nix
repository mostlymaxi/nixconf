{pkgs, lib, config, osConfig, options, niri, ...}: with lib; let name = "niri"; in {
  imports = [ 
    niri.homeModules.niri
    ./stylix.nix
  ];

  options = {
    desktop = mkOption {
      type = types.enum [name];
    };
  };

  config = mkIf (config.desktop == name) {
    assertions = [
      {
        assertion = builtins.elem name osConfig.available-desktops;
        message = "${name} is not an available desktop environment";
      }
    ];

    # if we want wayland sessions to be defined by home-manager
    home.file.".wayland-session" = {
      source = "${pkgs.niri}/bin/niri-session";
      executable = true;
    };

    nixpkgs.overlays = [niri.overlays.niri];

    programs.niri = let gaps = 16; bar-height = 45; in {
      enable = true;

      settings.prefer-no-csd = true;
      settings.hotkey-overlay.skip-at-startup = true;
      settings.cursor.hide-after-inactive-ms = 3000;

      settings.environment = {
        DISPLAY = ":0";
      };

      settings.layout = {
        gaps = 16;
        always-center-single-column = true;
      };

      settings.window-rules = [
        {
          clip-to-geometry = true;
          geometry-corner-radius.bottom-left = 6.0;
          geometry-corner-radius.bottom-right = 6.0;
          geometry-corner-radius.top-left = 6.0;
          geometry-corner-radius.top-right = 6.0;

          max-height = 1080 - 2 * gaps - bar-height;
        }
        {
          matches = [{ app-id = "^foot|footclient$"; }];
          default-column-width = { proportion = 1.0 / 2.0; };
          open-maximized = true;
          opacity = .9;
        }
        {
          matches = [{ app-id = "^firefox$"; }];
          border.active.gradient = {
            from = "orange";
            to = "red";
            angle = 45;
          };
        }
        {
          matches = [{ app-id = "obs"; }];
          block-out-from = "screencast";
        }
        {
          # doesn't work for some reason
          matches = [{ app-id = "satty"; }];
          open-fullscreen = true;
        }
      ];

      settings.binds = with config.lib.niri.actions; {
        "Mod+Shift+Slash".action = show-hotkey-overlay;
        "Mod+Return".action = spawn "${config.launchTerminal}";
        "Mod+D".action = spawn "${config.launchLauncher}";

        "Mod+P".action = screenshot-screen;
        "Mod+Control+P".action = spawn "bash" "-c" "grim - | satty -f -";
        "Mod+Shift+P".action = screenshot-window;

        "Mod+Q".action = close-window;
        "Mod+Shift+E".action = quit { skip-confirmation = true; };

        "Mod+H".action = focus-column-left;
        "Mod+L".action = focus-column-right;
        "Mod+K".action = focus-window-up;
        "Mod+J".action = focus-window-down;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+J".action = move-window-down;

        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;

        "Mod+Shift+1".action = move-window-to-workspace 1;
        "Mod+Shift+2".action = move-window-to-workspace 2;
        "Mod+Shift+3".action = move-window-to-workspace 3;
        "Mod+Shift+4".action = move-window-to-workspace 4;
        "Mod+Shift+5".action = move-window-to-workspace 5;
        "Mod+Shift+6".action = move-window-to-workspace 6;
        "Mod+Shift+7".action = move-window-to-workspace 7;
        "Mod+Shift+8".action = move-window-to-workspace 8;
        "Mod+Shift+9".action = move-window-to-workspace 9;

        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Minus".action = set-column-width "-10%";

        "Mod+Shift+Equal".action = set-window-height "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";

        "Mod+R".action = switch-preset-column-width;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+C".action = center-column;

        "Mod+Comma".action = consume-or-expel-window-left;
        "Mod+Period".action = consume-or-expel-window-right;

      };
    };
  };
}

