{pkgs, ...}: {
  fonts = {
    fontconfig.enable = true;
  };


  home.packages = with pkgs; [
    font-awesome

    cascadia-code
    noto-fonts
    noto-fonts-emoji
  ];
}

