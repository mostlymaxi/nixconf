{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    # archives
    zip
    unzip
    p7zip
    zstd

    # utils
    ripgrep
    # yq-go # https://github.com/mikefarah/yq
    htop
    nnn # tui folder
    fzf
    hyfetch
    grc
    inputs.wlavu.packages.${pkgs.system}.default

    # misc
    libnotify
    xdg-utils
    xwayland
    # graphviz

    # qt
    # libsForQt5.qtstyleplugin-kvantum
    # libsForQt5.qt5ct
    #
    # productivity
    rustup
    clang

    vesktop

    # cloud native
    docker-compose
  ];

  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
      };
    };

    fastfetch = {
      enable = true;
      settings = {
        schema = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        display = {
          separator = " ";
        };
        modules = [
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
        ];
      };
    };

    btop.enable = true; # replacement of htop/nmon
    eza.enable = true; # A modern replacement for ‘ls’
    jq.enable = true; # A lightweight and flexible command-line JSON processor
    ssh.enable = true;
  };

  # qt = {
  #   enable = true;
  #   platformTheme = "qt5ct";
  #   # style.name = "kvantum";
  # };
  #
  services = {
    # notification daemon
    mako = {
      enable = true;

      settings = {
        defaultTimeout = 15000;

        margin = "24";
        padding = "8";
        borderSize = 2;
        borderRadius = 8;
        width = 300;
        height = 160;
      };
    };

    # auto mount usb drives
    udiskie.enable = true;
  };
}
