{
  lib,
  config,
  osConfig,
  ...
}:
with lib;
{

  config = mkIf config.programs.core.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        schema = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        display = {
          separator = " ";
        };
        modules = mkMerge [
          (mkIf (!osConfig.host.is_headless) [
            "break"
            {
              type = "host";
              key = "╭─󰌢";
              keyColor = "green";
            }
            {
              type = "cpu";
              key = "├─󰻠";
              keyColor = "green";
            }
            {
              type = "gpu";
              key = "├─󰍛";
              keyColor = "green";
            }
            {
              type = "disk";
              key = "├─";
              keyColor = "green";
            }
            {
              type = "memory";
              key = "├─󰑭";
              keyColor = "green";
            }
            {
              type = "swap";
              key = "├─󰓡";
              keyColor = "green";
            }
            {
              type = "display";
              key = "╰─󰍹";
              keyColor = "green";
            }
            "break"
            {
              type = "shell";
              key = "╭─";
              keyColor = "yellow";
            }
            {
              type = "terminal";
              key = "├─";
              keyColor = "yellow";
            }
            {
              type = "de";
              key = "├─";
              keyColor = "yellow";
            }
            {
              type = "wm";
              key = "├─";
              keyColor = "yellow";
            }
            {
              type = "terminalfont";
              key = "╰─";
              keyColor = "yellow";
            }
            "break"
            {
              type = "title";
              key = "╭─";
              format = "{user-name}@{host-name}";
              keyColor = "blue";
            }
            {
              type = "os";
              key = "├─{icon}"; # Just get your distro's logo off nerdfonts.com
              keyColor = "blue";
            }
            {
              type = "kernel";
              key = "├─";
              keyColor = "blue";
            }
            {
              type = "uptime";
              key = "╰─󰅐";
              keyColor = "blue";
            }
          ])
          (mkIf (osConfig.host.is_headless) [
            "break"
            {
              type = "host";
              key = "╭─󰌢";
              keyColor = "green";
            }
            {
              type = "cpu";
              key = "├─󰻠";
              keyColor = "green";
            }
            {
              type = "gpu";
              key = "├─󰍛";
              keyColor = "green";
            }
            {
              type = "disk";
              key = "├─";
              keyColor = "green";
            }
            {
              type = "memory";
              key = "├─󰑭";
              keyColor = "green";
            }
            {
              type = "swap";
              key = "╰─󰓡";
              keyColor = "green";
            }
            "break"
            {
              type = "shell";
              key = "╭─";
              keyColor = "yellow";
            }
            {
              type = "terminal";
              key = "╰─";
              keyColor = "yellow";
            }
            "break"
            {
              type = "title";
              key = "╭─";
              format = "{user-name}@{host-name}";
              keyColor = "blue";
            }
            {
              type = "os";
              key = "├─{icon}"; # Just get your distro's logo off nerdfonts.com
              keyColor = "blue";
            }
            {
              type = "kernel";
              key = "├─";
              keyColor = "blue";
            }
            {
              type = "uptime";
              key = "╰─󰅐";
              keyColor = "blue";
            }
          ])
        ];

      };
    };
  };

}
