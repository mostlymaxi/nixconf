{lib, ...}: {
  imports = [
    ./browsers.nix
    ./common.nix
    ./git.nix
    ./media.nix
    ./fonts.nix
    ./waybar
  ];
  
   options.programs = { enable = lib.mkEnableOption "programs"; };
}
