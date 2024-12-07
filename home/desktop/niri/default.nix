{pkgs, lib, config, options, niri, ...}: {
  imports = [ niri.homeModules.niri ];

  config = lib.mkIf (config.desktop == "niri") {
    home.file.".wayland-session" = {
      source = "${pkgs.niri}/bin/niri-session";
      executable = true;
    };

    programs.niri.package = pkgs.niri;

    programs.niri = {
      enable = true;

      settings.window-rules = [
	{
	  matches = [{ app-id = "^foot$"; }];
	  default-column-width = { proportion = 1.0 / 2.0; };
	}
	{
	  matches = [{ app-id = "^footclient$"; }];
	  default-column-width = { proportion = 1.0 / 2.0; };
	}
      ];
      
      settings.binds = with config.lib.niri.actions; {
        "Mod+Return".action = spawn "${config.launchTerminal}";
	"Mod+D".action = spawn "${config.launchLauncher}";

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
	"Mod+C".action = center-column;
	
	"Mod+Comma".action = consume-window-into-column;
	"Mod+Period".action = expel-window-from-column;

      };
    };
  };
}

