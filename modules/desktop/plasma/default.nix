{...}: {
  services = {
    xserver.enable = false;

    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true; #disable for qt6 full version
    };
  };
}
