{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
{

  imports = [ ./fastfetch.nix ];

  config = mkIf config.programs.core.enable {
    home.packages = with pkgs; [
      # ssh
      openssh # default version in macos seems incomplete

      # archives
      zip
      unzip
      p7zip
      zstd

      # utils
      nh # nix cli
      gh
      watch
      ripgrep # better grep
      bottom # rust alternative to top
      htop # another alternative to top
      nnn # tui folder
      fzf # fuzzy finder
      grc # generic colorizer

      # containerization
      docker-compose
      kubectl

      go
    ];

    programs = {
      bat = {
        enable = true;

        config = {
          pager = "less -FR";
          theme = "eldritch";
        };

        themes = {
          eldritch = {
            src = pkgs.fetchFromGitHub {
              owner = "eldritch-theme";
              repo = "bat"; # Bat uses sublime syntax for its themes
              rev = "33f8a2543f626637e8d85356e85bf32eee414f17";
              sha256 = "sha256-zZbe3eFxG/cC6s6vOnDvpVkDysCg+PkK5Uunr9oVGrU=";
            };
            file = "Eldritch.tmTheme";
          };
        };
      };

      btop.enable = true; # replacement of htop/nmon
      eza.enable = true; # A modern replacement for ‘ls’
      jq.enable = true; # A lightweight and flexible command-line JSON processor
      ssh.enable = true;
    };
  };
}
