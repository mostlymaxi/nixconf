{lib, ...}: {
  imports = [
    ./browsers.nix
    ./common.nix
    ./git.nix
    ./media.nix
    ./waybar.nix
    ./fonts.nix
  ];
  
   options.programs = { enable = lib.mkEnableOption "programs"; };
}
