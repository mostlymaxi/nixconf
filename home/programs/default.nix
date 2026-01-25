{lib, ...}: {
  imports = [
    ./browsers.nix
    ./common.nix
    ./git.nix
    ./games.nix
    ./media.nix
    ./fonts.nix
    ./waybar
  ];
  
   options.programs = { enable = lib.mkEnableOption "programs"; };
}
