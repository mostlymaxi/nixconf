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
      ripgrep # better grep
      htop # alternate top
      nnn # tui folder
      fzf # fuzzy finder
      grc # generic colorizer

      # containerization
      docker-compose
    ];

    programs = {
      bat = {
        enable = true;
        config = {
          pager = "less -FR";
        };
      };

      btop.enable = true; # replacement of htop/nmon
      eza.enable = true; # A modern replacement for ‘ls’
      jq.enable = true; # A lightweight and flexible command-line JSON processor
      ssh.enable = true;
    };
  };
}
