{...}: {
  services.xserver.enable = false;

  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;
}
