{pkgs, ...}: {
  home.packages = with pkgs; [
    material-design-fonts
    font-awesome

    noto-fonts
    noto-fonts-emoji
  ];

  fonts.fontconfig.enable = true;
}
