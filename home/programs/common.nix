{
  lib,
  pkgs,
  ...
}: {
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
    fastfetch
    hyfetch
    grc

    # misc
    # libnotify
    xdg-utils
    # graphviz

    # qt
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct

    # productivity

    # IDE

    # cloud native
    docker-compose

    # db related
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
    aria2.enable = true;

    skim = {
      enable = true;
      defaultCommand = "rg --files --hidden";
      changeDirWidgetOptions = [
        "--preview 'exa --icons --git --color always -T -L 3 {} | head -200'"
        "--exact"
      ];
    };
  };

  qt = {
    enable = true;
    # platformTheme = "qt5ct";
  };

  services = {
    syncthing.enable = true;

    # auto mount usb drives
    udiskie.enable = true;
  };
}
