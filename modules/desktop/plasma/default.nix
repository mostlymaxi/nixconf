{config, ...}: 
  let 
    cfg = config.services.mydesktop.plasma;
  in {


  
  services = mkif cfg.enable {
    xserver.enable = false;

    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true; #disable for qt6 full version
    };

    displayManager.defaultSession = "plasma";
  };
}
