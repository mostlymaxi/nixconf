{pkgs, ...}: {
  home.packages = with pkgs; [
    # material-design-icons
    # font-awesome
    # fira-code-symbols

    # UGH IDK HOW TO FONT CORRECTLY
    # whats the difference between all these
    # nerd fonts patches and the default
    # NF fonts

    nerd-fonts.caskaydia-cove
    nerd-fonts.caskaydia-mono

    noto-fonts
    noto-fonts-emoji

  ];

  fonts.fontconfig.enable = true;
}
