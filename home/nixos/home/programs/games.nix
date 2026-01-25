{
  pkgs,
  ...
}:
# Media - control and enjoy audio/video
{
  # Media packages
  home.packages = with pkgs; [
  ];

  # Media programs we want to manage w/ HM
  # programs = {
  #   steam = {
  #     enable = true;
  #
  #     dedicatedServer.openFirewall = true;
  #   };
  # };
}
