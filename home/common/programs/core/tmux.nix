{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
{
  config = mkIf config.programs.core.enable {
    programs.tmux = {
      enable = true;
      mouse = true;
      keyMode = "vi";
      escapeTime = 0;
      historyLimit = 50000;
      terminal = "tmux-256color";
      extraConfig = ''
        set -ga terminal-overrides ",*:RGB"
        set -g focus-events on

        # default 10-char status-left truncates long session names into the window list
        set -g status-left-length 40

        # scratch popup: prefix+a floats a throwaway shell for quick one-off
        # commands, starting in the current pane's directory
        set -g popup-border-lines rounded
        bind a display-popup -E -w 75% -h 70% -T " scratch " -d "#{pane_current_path}"
      '';
    };

    # ai copilot that watches and types into tmux panes (https://tmuxai.dev)
    home.packages = [ pkgs.tmuxai ];

    # api key (opencode zen) is not managed by nix; set it once with:
    #   set -Ux TMUXAI_API_KEY ...
    xdg.configFile."tmuxai/config.yaml".text = ''
      default_model: glm

      models:
        glm:
          provider: openrouter
          model: glm-5.2
          api_key: ''${TMUXAI_API_KEY}
          base_url: https://opencode.ai/zen/v1

        kimi:
          provider: openrouter
          model: kimi-k2.7-code
          api_key: ''${TMUXAI_API_KEY}
          base_url: https://opencode.ai/zen/v1

        sonnet:
          provider: openrouter
          model: claude-sonnet-5
          api_key: ''${TMUXAI_API_KEY}
          base_url: https://opencode.ai/zen/v1

        haiku:
          provider: openrouter
          model: claude-haiku-4.5
          api_key: ''${TMUXAI_API_KEY}
          base_url: https://opencode.ai/zen/v1
    '';
  };
}
