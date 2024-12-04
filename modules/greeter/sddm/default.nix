{...}: {
  services = {
    displayManager = {
      # TODO: make this a variable in desktop
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
}
