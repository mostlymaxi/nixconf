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
        modules-right = [
          "cpu"
          "memory"
          "clock"
        ];
        "niri/workspaces" = {
          format = "{index}";
          on-click = "activate";
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
          format = "{usage}% 󰍛";
          tooltip = false;
        };
        memory = {
          format = "{}% 󰑭";
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

