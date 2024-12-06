{pkgs, ...}: {
  fonts.fontconfig.enableProfileFonts = true;

  home.packages = with pkgs; {
    noto-fonts
    
  };

}

