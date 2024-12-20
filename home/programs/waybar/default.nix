{lib, ...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = lib.mkAfter (builtins.readFile ./custom.css);

    settings = [
      {
        layer = "top";
        position = "bottom";
        spacing = "8";
        margin = "0 8 4";
        modules-left = [
          "niri/workspaces"
          # "wlr/taskbar"
        ];
        modules-center = [
          "custom/music"
        ];
        modules-right = [
          "cpu"
          "memory"
          "clock"
        ];
        "niri/workspaces" = {
          format = "{index}";
          on-click = "activate";
        };
        "custom/music" = {
          format = "{icon}{}";
          format-icons = {
            Playing = " ";
            Paused = "󰏥 ";
            Stopped = "&#x202d;ﭥ ";
          };
          escape = true;
          tooltip = true;
          exec = ./scripts/caway;
          return-type = "json";
          on-click = "playerctl play-pause";
          on-scroll-up = "playerctl previous";
          on-scroll-down = "playerctl next";
          on-click-right = "g4music";
          max-length = 35;
        };
        "wlr/taskbar" = {
          format = "{icon}";
          tooltip-format = "{title}";
          icon-size = 14;
          on-click = "activate";
        };
        tray = {
          # icon-size = 16;
          spacing = 10;
        };
        clock = {
          timezone = "America/New York";
          tooltip-format = ''
            <big>{:%d %B %Y}</big>'';
          format = "{:%I:%M %p}";
        };
        cpu = {
          format = "{usage}% ";
          interval = 2;
          states = {
            warning = 50;
            critical = 80;
          };
          tooltip = false;
        };
        memory = {
          format = "{}% 󱘲";
          interval = 2;
          states = {
            warning = 50;
            critical = 80;
          };
        };
       # network = {
        #   format-wifi = "{essid} ({signalStrength}%) ";
        #   format-ethernet = "{ipaddr}/{cidr} 󰈀";
        #   tooltip-format = "{ifname} via {gwaddr} 󰈀";
        #   format-linked = "{ifname} (No IP) 󰈀";
        #   format-disconnected = "Disconnected ⚠";
        #   format-alt = "{ifname}: {ipaddr}/{cidr}";
        # };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          # on-click = "pavucontrol";
        };
      }
    ];
  };
}

