{...}: {
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    xserver.desktopManager.plasma6.enable = true;
  };
}
