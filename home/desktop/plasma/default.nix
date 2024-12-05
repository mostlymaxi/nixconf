{ pkgs, plasma-manager, ... }:

{
  imports = [
    plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;
    shortcuts = {
      "org.kde.konsole.desktop"."_launch" = "Meta+T";
    };

# 
#     panels = [
#       # Windows-like panel at the bottom
#       {
#         location = "bottom";
#         widgets = [
#           "org.kde.plasma.kickoff"
#           "org.kde.plasma.icontasks"
#           "org.kde.plasma.marginsseparator"
#           "org.kde.plasma.systemtray"
#           "org.kde.plasma.digitalclock"
#         ];
#       }
#       # Global menu at the top
#       {
#         location = "top";
#         height = 26;
#         widgets = [ "org.kde.plasma.appmenu" ];
#       }
#     ];
# 
#     #
#     # Some mid-level settings:
#     #
#     shortcuts = {
#       ksmserver = {
#         "Lock Session" = [
#           "Screensaver"
#           "Meta+Ctrl+Alt+L"
#         ];
#       };
# 
#       kwin = {
#         "Expose" = "Meta+,";
#         "Switch Window Down" = "Meta+J";
#         "Switch Window Left" = "Meta+H";
#         "Switch Window Right" = "Meta+L";
#         "Switch Window Up" = "Meta+K";
#       };
#     };
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
