{ pkgs, lib, ... }:

let
  eldritch = pkgs.vimUtils.buildVimPlugin {
    name = "eldritch";
    src = pkgs.fetchFromGitHub {
      owner = "eldritch-theme";
      repo = "eldritch.nvim";
      rev = "d0e95921989f4b8ae24d6071cacf1fb6f6877107";
      hash = "sha256-XfNfQgDARWg37IRzvcsxO1v+okL2LdjaKETqXfgArT8=";
    };
  };
in
{
  programs.nixvim = {
    extraPlugins = [
      eldritch
    ];

    colorscheme = "eldritch";
  };
}
