{pkgs, ...}: {
  home.packages = with pkgs; [
    material-design-icons
    font-awesome

    noto-fonts
    noto-fonts-emoji

    fira-code-symbols
  ];

  fonts.fontconfig.enable = true;
}
