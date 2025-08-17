{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  options = {
    terminal = {
      default = mkOption {
        type = types.enum [ "kitty" ];
      };

      kitty = {
        enable = mkEnableOption "kitty terminal";
      };
    };
  };

  config = mkIf config.terminal.kitty.enable {
    terminal.exec = mkIf (config.terminal.default == "kitty") "${pkgs.kitty}/bin/kitty";

    home.file.".config/kitty/ssh.conf".text = ''
      hostname *tenant-coreweave-vdi.coreweave.cloud
      color_scheme Eldritch
    '';

    programs.kitty = {
      enable = true;

      # themeFile = "Eldritch";

      settings = {
        cursor_shape = "block";

        font_family = mkIf (config.style.fonts.enable) "family='CaskaydiaCove Nerd Font Mono'";

        font_size = 16;

        shell = mkIf (config.shell.exec != "") "${config.shell.exec}";

        enable_audio_bell = "no";
        copy_on_select = "no";

        clear_all_shortcuts = "yes";
      };

      # MacOS keybindings, might need to add check if i ever use kitty on linux
      keybindings = {
        "cmd+t" = "new_tab";
        "cmd+w" = "close_tab";
        "cmd+c" = "copy_to_clipboard";
        "cmd+v" = "paste_from_clipboard";
        "cmd+f" = "toggle_fullscreen";
        "cmd+q" = "quit";

        "cmd+1" = "goto_tab 1";
        "cmd+2" = "goto_tab 2";
        "cmd+3" = "goto_tab 3";
        "cmd+4" = "goto_tab 4";
        "cmd+5" = "goto_tab 5";
        "cmd+6" = "goto_tab 6";
        "cmd+7" = "goto_tab 7";
        "cmd+8" = "goto_tab 8";
        "cmd+9" = "goto_tab 9";

        "cmd+equal" = "change_font_size all +2.0";

        "cmd+minus" = "change_font_size all -2.0";

        "cmd+0" = "change_font_size all 0";

        "cmd+{" = "scroll_to_prompt -1 0";
        "cmd+}" = "scroll_to_prompt 1 0";
        "cmd+shift+o" = "show_last_visited_command_output";

        "cmd+shift+g" = "scroll_end";
        "cmd+k" = "scroll_line_up";
        "cmd+j" = "scroll_line_down";
      };

      shellIntegration = {
        mode = "no-cursor";
      };
    };
  };
}
