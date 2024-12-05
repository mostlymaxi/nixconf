{
  programs.plasma = {
    enable = true;
    kwin = {
      edgeBarrier = 0; # Disables the edge-barriers introduced in plasma 6.1
      cornerBarrier = false;

      scripts.polonium.enable = true;
    };

  hotkeys.commands."launch-konsole" = {
        name = "Launch Konsole";
        key = "Meta+Shift+K";
        command = "konsole";
      };
 

    shortcuts = {
          kwin = {
        "Expose" = "Meta+,";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
      };
    };
# 
#     #
#     # Some low-level settings:
#     #
#     configFile = {
#       "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
#       "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "SF";
#       "kwinrc"."Desktops"."Number" = {
#         value = 8;
#         # Forces kde to not change this value (even through the settings app).
#         immutable = true;
#       };
#     };
  };
}
