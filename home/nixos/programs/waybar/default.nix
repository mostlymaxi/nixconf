{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  icon =
    glyph:
    if config.stylix.enable then
      "<span color='${config.lib.stylix.colors.withHashtag.base0C}'>${glyph}</span>"
    else
      glyph;

  gpu-busy = pkgs.writeShellApplication {
    name = "gpu-busy";
    runtimeInputs = [
      pkgs.gnugrep
      pkgs.gawk
    ];
    text = builtins.readFile ./gpu-busy.sh;
  };
in
{
  stylix.targets.waybar.addCss = false;

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = lib.mkAfter (builtins.readFile ./custom.css);

    settings = [
      {
        layer = "top";
        position = "bottom";
        # must be an integer; waybar ignores a string here
        spacing = 16;
        margin = "0 8 4";
        modules-left = [
          "niri/workspaces"
          "custom/peak-meter"
        ];
        modules-center = [
          "custom/music"
        ];
        modules-right = [
          "group/stats"
          "clock"
        ];

        "niri/workspaces" = {
          format = "{index}";
          on-click = "activate";
        };

        "custom/peak-meter" = {
          format = "{}";
          # the meter draws itself with pango markup
          escape = false;
          exec = lib.escapeShellArgs (
            [
              (lib.getExe inputs.peak-meter-way.packages.${pkgs.stdenv.hostPlatform.system}.default)
              "--width"
              "36"
            ]
            ++ lib.optionals config.stylix.enable (
              with config.lib.stylix.colors.withHashtag;
              [
                "--color-low"
                base0B
                "--color-warn"
                base0A
                "--color-hot"
                base08
              ]
            )
          );
          return-type = "json";
          # come back if pipewire restarts
          restart-interval = 2;
        };

        "custom/music" = {
          format = "{icon}{text}";
          format-icons = {
            Playing = " ";
            Paused = "󰏥 ";
            Stopped = "󰓛 ";
          };
          escape = true;
          tooltip = true;
          exec = lib.getExe inputs.caway.packages.${pkgs.stdenv.hostPlatform.system}.default;
          return-type = "json";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl previous";
          on-scroll-down = "playerctl next";
          on-click-right = "g4music";
          max-length = 35;
          # no player left: hide the pill instead of showing a lone icon
          hide-empty-text = true;
        };

        "group/stats" = {
          orientation = "inherit";
          modules = [
            "temperature"
            "cpu"
            "custom/gpu"
            "memory"
            "disk"
          ];
        };

        temperature = {
          # k10temp Tctl; the hwmonN index moves between boots, the PCI path does not
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
          format = "${icon "󰔏"} {temperatureC}°";
          interval = 2;
          warning-threshold = 70;
          critical-threshold = 85;
          tooltip = false;
        };

        cpu = {
          format = "${icon ""} {usage:02}%";
          interval = 2;
          states = {
            warning = 50;
            critical = 80;
          };
          tooltip = false;
        };

        "custom/gpu" = {
          format = "${icon "󰢮"} {text}%";
          exec = lib.getExe gpu-busy;
          return-type = "json";
          tooltip = false;
        };

        memory = {
          format = "${icon ""} {percentage:02}%";
          interval = 2;
          states = {
            warning = 50;
            critical = 80;
          };
          tooltip-format = "{used:0.1f} / {total:0.1f} GiB";
        };

        disk = {
          path = "/";
          format = "${icon "󰋊"} {percentage_used:02}%";
          interval = 30;
          states = {
            warning = 80;
            critical = 90;
          };
          tooltip-format = "{used} / {total} on {path}";
        };

        clock = {
          timezone = "America/New_York";
          format = "{:%a %b %d · %I:%M %p}";
          tooltip-format = "<big>{:%A, %d %B %Y}</big>";
        };
      }
    ];
  };
}
