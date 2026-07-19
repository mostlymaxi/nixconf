{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib;
{
  options = {
    terminal = {
      default = mkOption {
        type = types.enum [ "ghostty" ];
      };

      ghostty = {
        enable = mkEnableOption "ghostty terminal";
      };
    };
  };

  config = mkIf config.terminal.ghostty.enable {
    terminal.exec = mkIf (config.terminal.default == "ghostty") (
      if pkgs.stdenv.hostPlatform.isDarwin then
        "/Applications/Ghostty.app/Contents/MacOS/ghostty"
      else
        "${pkgs.ghostty}/bin/ghostty"
    );

    xdg.configFile = {
      "ghostty/shaders/cursor_warp.glsl".source = ./shaders/cursor_warp.glsl;
      "ghostty/shaders/ripple_cursor.glsl".source = ./shaders/ripple_cursor.glsl;
    };

    programs.ghostty = {
      enable = true;
      # on darwin the app is installed as a homebrew cask, home-manager only manages config
      package =
        if pkgs.stdenv.hostPlatform.isDarwin then
          null
        else
          inputs.ghostty-nightly.packages.${pkgs.stdenv.hostPlatform.system}.ghostty;

      settings = {
        command = mkIf (config.shell.exec != "") config.shell.exec;
        cursor-style = "block";
        cursor-style-blink = false;
        shell-integration-features = "no-cursor";
        custom-shader = [
          "shaders/cursor_warp.glsl"
          "shaders/ripple_cursor.glsl"
        ];
        custom-shader-animation = "always";

        # vim-like scrollback navigation (alt+v to enter, esc/q to exit)
        # alt+s opens current screen in $EDITOR
        keybind = [
          "alt+s=write_screen_file:open"
          "super+shift+j=jump_to_prompt:1"
          "super+shift+k=jump_to_prompt:-1"
          "alt+v=activate_key_table:vim"
          "vim/j=scroll_page_lines:1"
          "vim/k=scroll_page_lines:-1"
          "vim/ctrl+d=scroll_page_down"
          "vim/ctrl+u=scroll_page_up"
          "vim/g>g=scroll_to_top"
          "vim/shift+g=scroll_to_bottom"
          "vim/slash=start_search"
          "vim/n=navigate_search:next"
          "vim/escape=deactivate_key_table"
          "vim/q=deactivate_key_table"
        ];
      };
    };
  };
}
