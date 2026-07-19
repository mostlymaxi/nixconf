{
  lib,
  config,
  osConfig,
  ...
}:
with lib;
let
  # desktop.default is a nixos option, so fall back on darwin
  hasDesktop = (osConfig.desktop.default or "none") != "none";

  # draws the ╭─/├─/╰─ tree corners by position so modules can be
  # added or removed without touching their neighbours
  section =
    keyColor: mods:
    [ "break" ]
    ++ imap0 (
      i: mod:
      mod
      // {
        inherit keyColor;
        key = (if i == 0 then "╭─" else if i == length mods - 1 then "╰─" else "├─") + mod.key;
      }
    ) mods;
in
{

  config = mkIf config.programs.core.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        schema = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        display = {
          separator = " ";
        };
        modules =
          section "green" (
            [
              {
                type = "host";
                key = "󰌢";
              }
              {
                type = "cpu";
                key = "󰻠";
              }
              {
                type = "gpu";
                key = "󰍛";
              }
              {
                type = "disk";
                key = "";
              }
              {
                type = "memory";
                key = "󰑭";
              }
              {
                type = "swap";
                key = "󰓡";
              }
            ]
            ++ optionals hasDesktop [
              {
                type = "display";
                key = "󰍹";
              }
            ]
          )
          ++ section "yellow" (
            [
              {
                type = "shell";
                key = "";
              }
              {
                type = "terminal";
                key = "";
              }
            ]
            ++ optionals hasDesktop [
              {
                type = "de";
                key = "";
              }
              {
                type = "wm";
                key = "";
              }
              {
                type = "terminalfont";
                key = "";
              }
            ]
          )
          ++ section "blue" [
            {
              type = "title";
              key = "";
              format = "{user-name}@{host-name}";
            }
            {
              type = "os";
              key = "{icon}"; # Just get your distro's logo off nerdfonts.com
            }
            {
              type = "kernel";
              key = "";
            }
            {
              type = "uptime";
              key = "󰅐";
            }
          ];

      };
    };
  };

}
