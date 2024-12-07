{lib, ...}: {
  imports = [
    ./browsers.nix
    ./common.nix
    ./git.nix
    ./media.nix
    ./xdg.nix
  ];
  
   options.programs = { enable = lib.mkEnableOption "programs"; };
}
