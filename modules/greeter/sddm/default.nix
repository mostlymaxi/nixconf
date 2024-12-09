{pkgs, specialArgs, ...}: {
  services = {
    xserver.enable = false;

    displayManager = {
      sessionPackages = [pkgs.niri];

      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
}
